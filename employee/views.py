# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from datetime import datetime

from django.contrib import messages
from django.db import connections
from django.utils.decorators import method_decorator
from django.views.decorators.clickjacking import xframe_options_exempt
from django.views.decorators.csrf import csrf_exempt
from django.views.generic.edit import FormView
from easy_pdf.rendering import render_to_pdf_response
from functools import reduce

from employee.forms import WorkingLetterForm


@method_decorator(xframe_options_exempt, name='dispatch')
@method_decorator(csrf_exempt, name='dispatch')
class WorkingLetterView(FormView):
    template_name = 'employee/working-letter.tpl'
    form_class = WorkingLetterForm
    success_url = '.'

    def form_valid(self, form):
        def get_initial_date(view, document):
            databases = ('cambridge', 'farmatech', 'humax')
            sql = "SELECT TOP 1 * FROM {} WHERE Empleado = %s ORDER BY Inicial DESC".format(view), [document]

            for db in databases:
                cursor = connections[db].cursor()
                cursor.execute(*sql)

                rows = dict_fetchall(cursor)

                if not rows:
                    continue

                return rows[0]['Inicial'], db

            return None, ''

        def dict_fetchall(cursor):
            columns = [col[0] for col in cursor.description]
            return [
                dict(zip(columns, row))
                for row in cursor.fetchall()
            ]

        def get_rows(view, document, initial_date, db):
            sql = "SELECT * FROM {} WHERE Empleado = %s AND Inicial = %s".format(view), [document, initial_date]

            cursor = connections[db].cursor()
            cursor.execute(*sql)

            return dict_fetchall(cursor)

        nits = dict(
            cambridge='900348955-8',
            farmatech='900090839-1',
            humax='811038881-9'
        )


        def get_commission(document, db):
            sql = "SELECT * FROM v_PromediosNomina WHERE Codigo = %s", [document]

            cursor = connections[db].cursor()
            cursor.execute(*sql)

            return dict_fetchall(cursor)


        def get_context_letter(document, initial_date, db):
            rows = get_rows('vPcarta', document, initial_date, db)

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

            try:
                comission = get_commission(document, db)[0]['PR_COMISION']
            except IndexError:
                comission = 0

            date_start = rows[0]['Ingreso_Emplea']
            context = dict(
                company=db,
                nit=nits[db],
                date="{} de {} de {}".format(today.day, months[today.month - 1], today.year),
                name=rows[0]['Nombre_Empleado'].strip(),
                document="{:,}".format(int(document)).replace(',', '.'),
                date_start="{} de {} de {}".format(date_start.day, months[date_start.month - 1], date_start.year),
                contract_type=contract_types[rows[0]['Tipo_Contrato'].strip()],
                position=rows[0]['Nombre_Cargo'].strip(),
                salary=rows[0]['Basico'],
                assistance=0,
                comission=comission
            )

            for row in rows:
                concept = row['Nombre_Concepto'].strip()
                if concept == 'BENEFICIO DE ALIMENTACION GF':
                    context['assistance'] += row['Devengado']

            context['assistance'] *= 2

            return context

        def get_context_bill(document, initial_date, db):
            rows = get_rows('vPcolilla', document, initial_date, db)

            if not rows:
                return dict()

            today = datetime.today()

            context = dict(
                company=db,
                nit=nits[db],
                name=rows[0]['Nombre_Empleado'].strip(),
                position=rows[0]['Nombre_Cargo'].strip(),
                lapse=rows[0]['Inicial'].strftime("%Y.%m.%d") + " al " + rows[0]['Final'].strftime("%Y.%m.%d"),
                document=document,
                salary="{:,.2f}".format(rows[0]['Basico']),
                dependency=rows[0]['Nombre_Dependencia'].strip(),
                date=today.strftime("%Y.%m.%d"),
                bank=rows[0]['Nombre_Banco'].strip(),
                days=rows[0]['Dias'],
                rows=rows,
                total_income=reduce(lambda x, y: x + y['Devengado'], rows, 0),
                total_deducted=reduce(lambda x, y: x + y['Deducido'], rows, 0),
            )

            context['to_pay'] = context['total_income'] + context['total_deducted']

            return context

        action = self.request.POST.get('action')
        context = template = filename = None
        document = form.cleaned_data['document']
        db_view = 'vPcarta' if action == 'letter' else 'vPcolilla'
        initial_date, db = get_initial_date(db_view, document)

        if initial_date is None:
            messages.add_message(self.request, messages.ERROR, 'Su cédula no se encuentra registrada, recuerde ingresarla sin puntos')
            return self.render_to_response(self.get_context_data())

        if action == 'letter':
            template = 'employee/working-letter-pdf.tpl'
            context = get_context_letter(document, initial_date, db)
            filename = document + '-carta.pdf'
        elif action == 'bill':
            template = 'employee/pay-bill-pdf.tpl'
            context = get_context_bill(document, initial_date, db)
            filename = document + '-colilla.pdf'

        if context:
            return render_to_pdf_response(
                request=self.request,
                template=template,
                download_filename=filename,
                context=context
            )
        else:
            messages.add_message(self.request, messages.ERROR, 'Su cédula no se encuentra registrada, recuerde ingresarla sin puntos')
            return self.render_to_response(self.get_context_data())
