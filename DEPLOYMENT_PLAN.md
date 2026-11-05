# خطة النشر (Deployment Plan)

## هدف
نشر نسخة Andarama مستقلة على Runflare باسم خدمة vtour-andarama في مشروع VTour منفصل، مع الحفاظ على البنية الحالية وعدم لمس خدمة bazarbaaz (ID: 37622/87432).

## تحليل سريع للمستودع
- الفرع: main
- آخر كوميت: 771eb9a
- التطبيق: Monorepo (pnpm) مع apps/api, apps/studio, apps/web, packages/*
- وضع النشر الذاتي: Node server apps/api/src/node.ts (يستمع على 0.0.0.0:8788)
- قاعدة البيانات: SQLite في /data/andarama.db
- الملفات المرفوعة: /data/storage/
- المهاجرات: packages/db/migrations
- أصول ثابتة: Studio + landing + docs

## إعدادات Docker
- Dockerfile: deploy/docker/Dockerfile (multi-stage)
- Build context: جذر المستودع (../.. من deploy/docker/)
- المنفذ الداخلي: 8788
- Volume: /data
- Healthcheck: GET http://localhost:8788/api/v1/health
- Runtime deps: better-sqlite3, sharp, ws, nodemailer

## متغيرات بيئة أساسية
- APP_SECRET (إلزامي)
- PUBLIC_URL (يجب أن يطابق النطاق العام HTTPS)
- ADMIN_EMAILS (اختياري)
- DATA_DIR=/data
- PORT=8788

## استراتيجية النشر على Runflare
1. إعداد مساحة عمل معزولة
2. إعداد مستودع Git مخصص لـ vtour-andarama
3. التأكد من مسار Dockerfile وسياق البناء الصحيح
4. إنشاء خدمة Docker معزولة في مشروع VTour منفصل
5. ربط القرص الدائم /data
6. ضبط المتغيرات والأسرار
7. أول نشر مع تعطيل النشر التلقائي
8. اختبار القبول

## قيود حرجة
- لا تلمس خدمة bazarbaaz أبداً
- لا تعيد استخدام أحجام/أسرار
- لا تستخدم docker compose down -v أو أوامر حذف أحجام
- SQLite - مثيل واحد فقط
- /t/{slug} يجب أن يبقى كما هو
