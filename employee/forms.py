from django import forms


class WorkingLetterForm(forms.Form):
    document = forms.CharField(label='Documento', max_length=50)
