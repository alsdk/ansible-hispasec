from pretix.settings import *

LOGGING['handlers']['mail_admins']['include_html'] = True
STATICFILES_STORAGE = 'django.contrib.staticfiles.storage.ManifestStaticFilesStorage'
STATIC_ROOT = "/data/static/"

SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SECURE = True

DEBUG = False
