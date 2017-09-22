{% extends "easy_pdf/base.html" %}

{% block content %}
  <div id="content">
    <p>La Estrella, {{ date }}</p>

    <br><br><br>

    <h3 style="text-align: center;">A QUIEN PUEDA INTERESAR</h3>

    <br><br><br>

    <p style="text-align: justify;">
      Hacemos constar que el/la señor(a) <span style="text-transform: uppercase">{{ name }}</span>, identificado(a) con
      cédula de ciudadanía número {{ document }}, labora con nuestra empresa desde el {{ date_start }}, con contrato a
      {{ contract_type }}, desempeña el cargo de <span style="text-transform: uppercase">{{ position }}</span>, devenga
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

    <br><br><br>

    <p>
      MONICA MARIA DUQUE SEPULVEDA
      <br>
      Gerente de Gestión Humana</p>
  </div>
{% endblock %}
