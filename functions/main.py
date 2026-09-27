from firebase_functions import firestore_fn, https_fn
from firebase_functions.options import set_global_options
from firebase_admin import initialize_app, firestore, messaging

set_global_options(max_instances=10)

initialize_app()

COLECCION_VENTAS = "sales"
COLECCION_USUARIOS = "users"
CAMPO_USUARIO = "user_id"
CAMPO_TOKENS = "fcm_tokens"


@firestore_fn.on_document_created(document=f"{COLECCION_VENTAS}/{{saleId}}")
def on_sale_created(
    event: firestore_fn.Event[firestore_fn.DocumentSnapshot],
) -> None:
    db = firestore.client()

    sale_id = event.params["saleId"]
    sale_data = event.data.to_dict() if event.data else None

    print(f"[+] Trigger disparado para la venta: {sale_id}")

    if not sale_data:
        print(f"[!] La venta {sale_id} no tiene datos")
        return

    user_id = sale_data.get(CAMPO_USUARIO)
    if not user_id:
        print(f"[!] La venta {sale_id} no tiene el campo '{CAMPO_USUARIO}'")
        return

    user_snap = db.collection(COLECCION_USUARIOS).document(str(user_id)).get()
    if not user_snap.exists:
        print(f"[!] No existe el usuario '{user_id}'")
        return

    user_data = user_snap.to_dict() or {}
    tokens = [
        token
        for token in user_data.get(CAMPO_TOKENS, [])
        if isinstance(token, str) and token.strip()
    ]

    if not tokens:
        print(f"[!] El usuario '{user_id}' no tiene tokens FCM")
        return

    total = sale_data.get("total", 0)
    currency = sale_data.get("currency", "USD")
    concept = sale_data.get("concept", "Compra")

    title = "Venta confirmada ✅"
    body = f"Tu compra de {currency} {total} por {concept} ya fue procesada."

    message = messaging.MulticastMessage(
        notification=messaging.Notification(title=title, body=body),
        data={
            "feature": "sale_details",
            "sale_id": sale_id,
            "total": str(total),
        },
        tokens=tokens,
    )

    try:
        response = messaging.send_each_for_multicast(message)
    except Exception as e:
        print(f"[!] Error enviando la notificación: {e}")
        return

    print(f"[+] Notificaciones enviadas correctamente: {response.success_count}")
    print(f"[+] Notificaciones con error: {response.failure_count}")

    for index, result in enumerate(response.responses):
        if result.success:
            print(f"[+] Token {index + 1}: enviado correctamente")
        else:
            print(f"[!] Token {index + 1}: {result.exception}")


@https_fn.on_request()
def ping(req: https_fn.Request) -> https_fn.Response:
    return https_fn.Response("Experience-App functions OK")
