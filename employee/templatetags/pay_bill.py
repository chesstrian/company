from django import template

register = template.Library()


@register.filter
def multiply_by_minus_one(value):
    return value * -1


@register.filter
def num_2_words(value):
    from num2words import num2words
    return num2words(int(value), lang='es-CO')
