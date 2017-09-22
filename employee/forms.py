from django import forms


class WorkingLetterForm(forms.Form):
    document = forms.CharField(max_length=50)
