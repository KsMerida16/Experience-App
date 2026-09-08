"""
Lee una venta de Firestore, obtiene el usuario asociado,
recupera sus tokens FCM y envía una notificación push.

Adaptado para Experience-App.
"""

import sys
import warnings
from pathlib import Path

import firebase_admin
from firebase_admin import credentials, firestore, messaging


warnings.filterwarnings("ignore", category=DeprecationWarning)

SERVICE_ACCOUNT = (
    Path(__file__).resolve().parent / "serviceAccountKey.json"
)

VENTA_ID = "XaemdKVWxpnJ3fnaswXw"

COLECCION_VENTAS = "sales"
COLECCION_USUARIOS = "users"

CAMPO_USUARIO = "user_id"
CAMPO_TOKENS = "fcm_tokens"

try:
    cred = credentials.Certificate(str(SERVICE_ACCOUNT))

    firebase_admin.initialize_app(cred)

    db = firestore.client()

except Exception as e:
    sys.exit(f"[!] Error inicializando Firebase: {e}")

print("========================================")
print("1. CONSULTANDO VENTA")
print("========================================")

venta_snap = (
    db.collection(COLECCION_VENTAS)
    .document(VENTA_ID)
    .get()
)


if not venta_snap.exists:
    sys.exit(
        f"[!] No existe la venta '{VENTA_ID}' "
        f"en la colección '{COLECCION_VENTAS}'"
    )


venta = venta_snap.to_dict()

print(f"[+] Venta encontrada: {VENTA_ID}")
print(f"[+] Datos de la venta: {venta}")

print()
print("========================================")
print("2. OBTENIENDO USUARIO")
print("========================================")

usuario_id = venta.get(CAMPO_USUARIO)


if not usuario_id:
    sys.exit(
        f"[!] La venta no tiene el campo '{CAMPO_USUARIO}'"
    )

print(f"[+] User ID encontrado: {usuario_id}")

print()
print("========================================")
print("3. CONSULTANDO USUARIO")
print("========================================")

usuario_snap = (
    db.collection(COLECCION_USUARIOS)
    .document(str(usuario_id))
    .get()
)


if not usuario_snap.exists:
    sys.exit(
        f"[!] No existe el usuario '{usuario_id}' "
        f"en la colección '{COLECCION_USUARIOS}'"
    )


datos_usuario = usuario_snap.to_dict()

print(f"[+] Usuario encontrado: {usuario_snap.id}")

print(
    f"[+] Nombre: "
    f"{datos_usuario.get('name', '(sin nombre)')}"
)

print()
print("========================================")
print("4. OBTENIENDO TOKENS FCM")
print("========================================")

tokens = datos_usuario.get(CAMPO_TOKENS, [])


if not tokens:
    sys.exit(
        f"[!] El usuario '{usuario_snap.id}' "
        f"no tiene tokens FCM en '{CAMPO_TOKENS}'"
    )
tokens = [
    str(token)
    for token in tokens
    if token
]


if not tokens:
    sys.exit("[!] No existen tokens FCM válidos.")


print(f"[+] Tokens encontrados: {len(tokens)}")

for index, token in enumerate(tokens, start=1):
    print(
        f"    Token {index}: "
        f"{token[:20]}..."
    )

print()
print("========================================")
print("5. CONSTRUYENDO NOTIFICACIÓN")
print("========================================")

total = venta.get("total", 0)

title = "Venta confirmada ✅"

body = (
    f"Tu compra por ${total} "
    f"ya está procesada"
)

data = {
    "feature": "sale_details",
    "sale_id": VENTA_ID,
    "total": str(total),
}


print(f"[+] Title: {title}")
print(f"[+] Body: {body}")
print(f"[+] Data: {data}")

print()
print("========================================")
print("6. ENVIANDO NOTIFICACIÓN")
print("========================================")


message = messaging.MulticastMessage(
    notification=messaging.Notification(
        title=title,
        body=body,
    ),
    data=data,
    tokens=tokens,
)


try:
    response = messaging.send_each_for_multicast(message)

except Exception as e:
    sys.exit(
        f"[!] Error enviando la notificación: {e}"
    )

print()
print("========================================")
print("RESULTADO")
print("========================================")

print(
    f"[+] Notificaciones enviadas correctamente: "
    f"{response.success_count}"
)

print(
    f"[+] Notificaciones con error: "
    f"{response.failure_count}"
)

for index, result in enumerate(response.responses):

    if result.success:
        print(
            f"[+] Token {index + 1}: "
            f"enviado correctamente"
        )

    else:
        print(
            f"[!] Token {index + 1}: "
            f"{result.exception}"
        )


print()
print("========================================")
print("PROCESO FINALIZADO")
print("========================================")