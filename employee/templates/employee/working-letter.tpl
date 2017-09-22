{% extends 'bootstrap4/bootstrap4.html' %}

{% load bootstrap4 %}
{% load static %}

{% block bootstrap4_content %}
  <div class="container">
    <img id="header" src="http://{{ request.get_host }}{% static 'employee/images/header.png' %}" style="width: 100%">

    <h2>Carta Laboral</h2>

    <hr>

    <form method="post" role="form" class="form">
      {% csrf_token %}
      {% bootstrap_form form %}
      {% bootstrap_button content='Enviar' button_type='submit' button_class='btn-primary' %}
    </form>
  </div>
{% endblock %}
