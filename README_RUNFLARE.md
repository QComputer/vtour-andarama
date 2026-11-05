# نشر Andarama على Runflare (VTour)

## ملخص
نشر مستقل لخدمة vtour-andarama على Runflare. يستخدم Dockerfile الموجود في deploy/docker/Dockerfile مع سياق بناء جذر المستودع.

## معلومات النشر
- مستودع المصدر: https://github.com/joseluissaorin/andarama
- كوميت: 771eb9a
- خدمة: vtour-andarama (منفصلة عن bazarbaaz)
- منفذ داخلي: 8788
- مسار البيانات: /data

## متطلبات
- قرص دائم مُركب على /data
- متغيرات: APP_SECRET, PUBLIC_URL, ADMIN_EMAILS
- نشر Git-based مع Dockerfile

## ملاحظات
- لا تعدل خدمة bazarbaaz الموجودة
- استخدم مثيل واحد فقط (SQLite)
- لا تقم بحذف أحجام البيانات
