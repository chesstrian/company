{% extends "easy_pdf/base.html" %}

{% load humanize %}
{% load pay_bill %}

{% block extra_style %}
  <style type="text/css">
    @page {
      margin: 1cm;
    }

    #content {
      font-family: Arial,sans-serif;
      font-size: 13px;
    }

    .block {
      display: inline-block;
    }

    .title-left {
      float: left;
    }

    .title-left > h2 {
      padding-left: 140px;
    }

    .title-left > h3 {
      padding-left: 20px;
    }

    .title-right {
      border: 1px solid black;
      border-radius: 5px;
      text-align: center;
      float: right;
      padding: 0 20px;
    }

    .employee {
      border: 1px solid black;
      border-radius: 5px;
      background-color: #6fb7ff;
      margin-top: 92px;
      padding: 5px 10px;
    }

    .employee-data {
      margin: 3px 0;
      border: 1px solid black;
      border-radius: 5px;
      padding: 5px 10px;
      font-size: 11px;
    }

    .left {
      width: 38%;
      float: left;
    }

    .right {
      width: 24%;
      float: right;
    }

    .center {
      width: 38%;
      margin: 0 auto;
    }

    table {
      width: 100%;
    }

    thead {
      text-align: center;
      background-color: #6fb7ff;
    }

    th, td {
      border: 1px solid black;
    }

    .bg-gray {
      background-color: #dfdfdf;
    }

    .bg-blue {
      background-color: #6fb7ff;
    }

    .footer {
      position: fixed;
      bottom: 0;
      width: 97%;
    }

    .total-words {
      border: 1px solid black;
      border-radius: 5px;
      vertical-align: top;
      font-size: 11px;
      padding: 10px;
      width: 60%;
    }

    .sign-space {
      height: 60px;
    }

    .sign-space > td {
      border: 1px solid black;
      border-radius: 5px;
      vertical-align: bottom;
      padding: 10px;
      width: 50%;
    }

    .text-right {
      text-align: right;
    }
  </style>
{% endblock %}

{% block content %}
  <div id="content">
    <div>
      <div class="block title-left">
        <h2>FARMATECH S.A.</h2>
        <h3>NIT. 900090839-1</h3>
      </div>
      <div class="block title-right">
        <h2>COMPROBANTE<br> DE NÓMINA</h2>
      </div>
    </div>

    <div class="employee">
      <strong>Datos del Empleado</strong>
    </div>

    <div class="employee-data">
      <div class="left">
        <p>
          <strong>Empleado: </strong>
          <span>{{ name }}</span>
        </p>
        <p>
          <strong>Cargo&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: </strong>
          <span>{{ position }}</span>
        </p>
        <p>
          <strong>Periodo&nbsp;&nbsp;&nbsp;&nbsp;: </strong>
          <span>{{ lapse }}</span>
        </p>
      </div>
      <div class="right">
        <p>
          <strong>Fecha&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: </strong>
          <span>{{ date }}</span>
        </p>
        <p>
          <strong>Banco&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: </strong>
          <span>{{ bank }}</span>
        </p>
        <p>
          <strong>Días pago: </strong>
          <span>{{ days|floatformat:2 }}</span>
        </p>
      </div>
      <div class="center">
        <p>
          <strong>Código&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: </strong>
          <span>{{ document }}</span>
        </p>
        <p>
          <strong>Salario&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: </strong>
          <span>${{ salary }}</span>
        </p>
        <p>
          <strong>Dependencia: </strong>
          <span>{{ dependency }}</span>
        </p>
      </div>
    </div>

    <table class="full-width">
      <thead>
        <tr>
          <th>Código</th>
          <th>Descripción</th>
          <th>Horas</th>
          <th>Devengados</th>
          <th>Deducciones</th>
        </tr>
      </thead>
      <tbody>
        {% for row in rows %}
          <tr class="{% if forloop.counter|divisibleby:2 %}bg-gray{% endif %}">
            <td>{{ row.Concepto }}</td>
            <td>{{ row.Nombre_Concepto }}</td>
            <td class="text-right">{% if row.Horas > 0 %}{{ row.Horas|floatformat:2 }}{% endif %}</td>
            <td class="text-right">{% if row.Devengado > 0 %}{{ row.Devengado|floatformat:2|intcomma }}{% endif %}</td>
            <td class="text-right">{% if row.Deducido < 0 %}{{ row.Deducido|multiply_by_minus_one|floatformat:2|intcomma }}{% endif %}</td>
          </tr>
        {% endfor %}
      </tbody>
    </table>

    <div class="footer">
      <table>
        <tr>
          <td rowspan="3" class="total-words">
            <span>Son:</span>
            <br>
            <span>{{ to_pay|num_2_words|upper }} PESOS 00/100</span>
          </td>
          <th class="bg-blue">Total Devengados</th>
          <td class="bg-gray text-right">{{ total_income|floatformat:2|intcomma }}</td>
        </tr>
        <tr>
          <th class="bg-blue">Total Deducciones</th>
          <td class="bg-gray text-right">{{ total_deducted|multiply_by_minus_one|floatformat:2|intcomma }}</td>
        </tr>
        <tr>
          <th class="bg-blue">Nómina por pagar</th>
          <td class="bg-gray text-right">{{ to_pay|floatformat:2|intcomma }}</td>
        </tr>
      </table>
      <table>
        <tr class="sign-space">
          <td>Firma del empleado:</td>
          <td>C. de C.</td>
        </tr>
      </table>
    </div>
  </div>
{% endblock %}
