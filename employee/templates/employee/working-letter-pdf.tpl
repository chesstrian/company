{% extends "easy_pdf/base.html" %}

{% load humanize %}
{% load static %}

{% block extra_style %}
    <style type="text/css">
        @page {
            margin: -8px;
        }

        img {
            width: 100%;
        }

        #content {
            font-family: Arial,sans-serif;
            font-size: 15px;
        }

        #sign {
          width: 200px;
        }

        #footer {
            position: fixed;
            bottom: 0;
        }

        .letter-content {
            margin: 0 2.5cm;
        }
    </style>
{% endblock %}

{% block content %}
  <div id="content">
    <img id="header" src="https://{{ request.get_host }}{% static 'employee/images/header.png' %}">

    <div class="letter-content">
      <p>La Estrella, {{ date }}</p>

      <br><br><br><br>

      <h3 style="text-align:center;">A QUIEN PUEDA INTERESAR</h3>

      <br><br><br><br>

      <p style="text-align:justify;line-height:25px;">
        Hacemos constar que el/la señor(a) <strong>{{ name }}</strong>, identificado(a) con cédula de ciudadanía número
        {{ document }}, labora con nuestra empresa desde el {{ date_start }}, con contrato a {{ contract_type }},
        desempeña el cargo de <strong>{{ position }}</strong>, devenga un salario básico mensual de
        ${{ salary|floatformat:2|intcomma }}{% if comission > 0 %}, un promedio de comisiones mensuales de
        ${{ comission|floatformat:2|intcomma }}{% endif %}{% if assistance > 0 %} mas un auxilio de alimentación grupo
        familiar mensual de ${{ assistance|floatformat:2|intcomma }} no constitutivo de salario{% endif %}.
      </p>

      <br>

      <p>
        Esta constancia se expide a solicitud del interesado.
      </p>

      <br>

      <p>
        Cordialmente,
      </p>

      <br><br><br><br>

      <img id="sign" src="https://{{ request.get_host }}{% static 'employee/images/diana.png' %}">
      <p>
        <strong>DIANA CATALINA JARAMILLO</strong>
        <br>
        Gerente de Gestión Humana
      </p>
    </div>

    <img id="footer" src="https://{{ request.get_host }}{% static 'employee/images/footer.png' %}">
  </div>
{% endblock %}
