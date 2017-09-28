# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from datetime import datetime

from django.contrib import messages
from django.db import connections
from django.views.generic.edit import FormView
from easy_pdf.rendering import render_to_pdf_response

from employee.forms import WorkingLetterForm


class WorkingLetterView(FormView):
    template_name = 'employee/working-letter.tpl'
    form_class = WorkingLetterForm
    success_url = '.'

    def form_valid(self, form):
        def get_initial_date():
            today = datetime.today()
            day = 1 if today.day > 15 else 16

            return today.replace(day=day, hour=0, minute=0, second=0, microsecond=0)

        def dict_fetchall(cursor):
            columns = [col[0] for col in cursor.description]
            return [
                dict(zip(columns, row))
                for row in cursor.fetchall()
            ]

        def get_rows(document, initial_date):
            databases = ('cambridge', 'farmatech', 'humax')
            sql = "SELECT * FROM vPcarta WHERE Empleado = %s AND Inicial = %s", [document, initial_date]

            for db in databases:
                cursor = connections[db].cursor()
                cursor.execute(*sql)

                rows = dict_fetchall(cursor)

                if not rows:
                    continue

                return rows
            return dict()

        def get_pdf_context(document, initial_date):
            rows = get_rows(document, initial_date)

            if not rows:
                return dict()

            today = datetime.today()
            months = (
                'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio',
                'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
            )

            contract_types = {
                'FIJO': 'Término Fijo',
                'INDEF': 'Término Indefinido'
            }

            date_start = rows[0]['Ingreso_Emplea']
            result = dict(
                date="{} de {} de {}".format(today.day, months[today.month - 1], today.year),
                name=rows[0]['Nombre_Empleado'].strip(),
                document="{:,}".format(int(document)).replace(',', '.'),
                date_start="{} de {} de {}".format(date_start.day, months[date_start.month -1 ], date_start.year),
                contract_type=contract_types[rows[0]['Tipo_Contrato'].strip()],
                position=rows[0]['Nombre_Cargo'].strip(),
                salary=0,
                assistance=0,
                comission=0
            )

            for row in rows:
                concept = row['Nombre_Concepto'].strip()
                if concept == 'SALARIO BASICO':
                    result['salary'] += row['Devengado']
                elif concept == 'BENEFICIO DE ALIMENTACION GF':
                    result['assistance'] += row['Devengado']
                elif concept in ('COMISIONES POR RECAUDO', 'COMISIONES POR VENTAS'):
                    result['comission'] += row['Devengado']

            result['salary'] = "{:,.2f}".format(result['salary']).replace(',', '.')
            result['assistance'] = "{:,.2f}".format(result['assistance']).replace(',', '.')
            result['comission'] = "{:,.2f}".format(result['comission']).replace(',', '.')

            return result

        context = get_pdf_context(form.cleaned_data['document'], get_initial_date())

        if context:
            return render_to_pdf_response(
                request=self.request,
                template='employee/working-letter-pdf.tpl',
                context=context
            )
        else:
            messages.add_message(self.request, messages.ERROR, 'Su cédula no se encuentra registrada, recuerde ingresarla sin puntos')
            return self.render_to_response(self.get_context_data())
