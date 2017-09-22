{% extends 'bootstrap4/bootstrap4.html' %}

{% block bootstrap4_title %}
  Working Letter Generator
{% endblock %}

{% load bootstrap4 %}

{% block bootstrap4_content %}
  <div class="container">
    <h2>Working Letter Generator</h2>

    <form method="post" role="form" class="form">
      {% csrf_token %}
      {% bootstrap_form form %}
      {% buttons submit='Submit' %}{% endbuttons %}
    </form>
  </div>
{% endblock %}
