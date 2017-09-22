{% extends "easy_pdf/base.html" %}

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
    <img id="header" src="http://{{ request.get_host }}{% static 'employee/images/header.png' %}">

    <div class="letter-content">
      <p>La Estrella, {{ date }}</p>

      <br><br><br><br>

      <h3 style="text-align:center;">A QUIEN PUEDA INTERESAR</h3>

      <br><br><br><br>

      <p style="text-align:justify;line-height:25px;">
        Hacemos constar que el/la señor(a) <strong style="text-transform: uppercase">{{ name }}</strong>, identificado(a) con
        cédula de ciudadanía número {{ document }}, labora con nuestra empresa desde el {{ date_start }}, con contrato a
        {{ contract_type }}, desempeña el cargo de <strong style="text-transform: uppercase">{{ position }}</strong>, devenga
        un salario básico mensual de ${{ salary }} un promedio de comisiones mensuales de ${{ comission }} mas un auxilio
        de alimentación grupo familiar mensual de ${{ assistance }} no constitutivo de salario.
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

      <p>
        <strong>MONICA MARIA DUQUE SEPULVEDA</strong>
        <br>
        Gerente de Gestión Humana
      </p>
    </div>

    <img id="footer" src="http://{{ request.get_host }}{% static 'employee/images/footer.png' %}">
  </div>
{% endblock %}
