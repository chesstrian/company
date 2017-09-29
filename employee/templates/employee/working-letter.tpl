{% extends 'bootstrap4/bootstrap4.html' %}

{% load bootstrap4 %}
{% load static %}

{% block bootstrap4_content %}
  <div class="container">
    {% bootstrap_messages %}

    <form method="post" role="form" class="form">
      {% csrf_token %}
      {% bootstrap_form form %}
      {% bootstrap_button content='Enviar' button_type='submit' button_class='btn-primary' %}
    </form>
  </div>
{% endblock %}
