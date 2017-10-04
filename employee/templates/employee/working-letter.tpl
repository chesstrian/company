{% extends 'bootstrap4/bootstrap4.html' %}

{% load bootstrap4 %}
{% load static %}

{% block bootstrap4_content %}
  <div class="container">
    {% bootstrap_messages %}

    <form method="post" role="form" class="form">
      {% csrf_token %}
      {% bootstrap_form form %}
      {% bootstrap_button content='Generar Carta Laboral' button_type='submit' name='action' value='letter' button_class='btn-primary' %}
      {% bootstrap_button content='Generar Colilla de Pago' button_type='submit' name='action' value='bill' button_class='btn-success' %}
    </form>
  </div>
{% endblock %}
