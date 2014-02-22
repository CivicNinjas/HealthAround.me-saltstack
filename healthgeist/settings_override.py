DEBUG = {{pillar.django.get('debug', 'False')}}
TEMPLATE_DEBUG = {{pillar.django.get('template_debug', 'False')}}

ALLOWED_HOSTS = ['{{pillar.django.allowed_host}}']

SECRET_KEY = '{{pillar.django.secret_key}}'

{% set db_engine = pillar[pillar.django.db_engine] %}
DATABASES = {
    'default': {
        'ENGINE': '{{pillar.django.db_engine_module}}',
        'NAME': '{{db_engine.app_db}}',
        'USER': '{{db_engine.app_owner}}',
        'PASSWORD': '{{db_engine.users[db_engine.app_owner].password}}',
        'HOST': '{{db_engine.get('host', '127.0.0.1')}}',
        'POST': '{{db_engine.get('port', '')}}'
    }
}
