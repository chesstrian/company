# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from datetime import datetime

from django.views.generic.edit import FormView
from easy_pdf.rendering import render_to_pdf_response

from employee.forms import WorkingLetterForm


class WorkingLetterView(FormView):
    template_name = 'employee/working-letter.tpl'
    form_class = WorkingLetterForm
    success_url = '.'

    def form_valid(self, form):
        today = datetime.today()
        context = dict(
            date=today.strftime('%d de %B de %Y'),
            name='Diego Armando Martinez Arbelaez',
            document=form.cleaned_data['document'],
            date_start='13 de febrero de 2012',
            contract_type='término indefinido',
            position='Ejecutivo de cuenta',
            salary='1.910.000.00',
            comission='5.794.000.00',
            assistance='400.000.00'
        )

        return render_to_pdf_response(
            request=self.request,
            template='employee/working-letter-pdf.tpl',
            context=context
        )
