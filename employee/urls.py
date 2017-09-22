from django.conf.urls import url

from employee import views

urlpatterns = [
    url(r'^working-letter/$', views.WorkingLetterView.as_view(), name='working-letter'),
]
