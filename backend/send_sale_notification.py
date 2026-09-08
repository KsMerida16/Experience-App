import sys
import warnings

import firebase_admin
from firebase_admin import credentials, firestore, messaging

warnings.filterwarnings("ignore", category=DeprecationWarning)


SERVICE_ACCOUNT_FILE = "serviceAccountKey.json"


def initialize_firebase():
    """
    Inicializa Firebase Admin SDK.
    """

    if not firebase_admin._apps:
        cred = credentials.Certificate(SERVICE_ACCOUNT_FILE)

        firebase_admin.initialize_app(cred)

    return firestore.client()


def get_sale(db, sale_id):
    """
    Consulta una venta por su sale_id.
    """

    sale_ref = db.collection("sales").document(sale_id)
    sale_snapshot = sale_ref.get()

    if not sale_snapshot.exists:
        print(f"\nNo existe la venta con sale_id: {sale_id}")
        return None

    sale_data = sale_snapshot.to_dict()

    print("\n=== VENTA ENCONTRADA ===")
    print(f"sale_id: {sale_id}")
    print(f"user_id: {sale_data.get('user_id')}")
    print(f"total: {sale_data.get('total')}")
    print(f"currency: {sale_data.get('currency')}")
    print(f"concept: {sale_data.get('concept')}")
    print(f"status: {sale_data.get('status')}")

    return sale_data


def get_user(db, user_id):
    """
    Consulta el usuario relacionado con la venta.
    """

    user_ref = db.collection("users").document(user_id)
    user_snapshot = user_ref.get()

    if not user_snapshot.exists:
        print(f"\nNo existe el usuario con UID: {user_id}")
        return None

    user_data = user_snapshot.to_dict()

    print("\n=== USUARIO ENCONTRADO ===")
    print(f"user_id: {user_id}")

    return user_data


def get_fcm_tokens(user_data):
    """
    Obtiene los tokens FCM almacenados en el usuario.
    """

    tokens = user_data.get("fcm_tokens", [])

    if not isinstance(tokens, list):
        print("\nEl campo fcm_tokens no tiene formato de lista.")
        return []

    tokens = [
        token
        for token in tokens
        if isinstance(token, str) and token.strip()
    ]

    print(f"\nTokens FCM encontrados: {len(tokens)}")

    return tokens


def send_notification(tokens, sale_id, sale_data):
    """
    Construye y envía la notificación FCM.
    """

    total = sale_data.get("total", 0)
    currency = sale_data.get("currency", "USD")
    concept = sale_data.get("concept", "Compra")

    title = "Compra realizada"

    body = (
        f"Tu compra de {currency} {total:.2f} "
        f"por {concept} fue procesada correctamente."
    )

    print("\n=== NOTIFICACIÓN ===")
    print(f"Title: {title}")
    print(f"Body: {body}")
    print(f"sale_id: {sale_id}")

    messages = []

    for token in tokens:
        message = messaging.Message(
            notification=messaging.Notification(
                title=title,
                body=body,
            ),
            data={
                "sale_id": sale_id,
                "type": "sale",
            },
            token=token,
        )

        messages.append(message)

    if not messages:
        print("\nNo existen tokens FCM para enviar la notificación.")
        return

    response = messaging.send_each(messages)

    print("\n=== RESULTADO DEL ENVÍO ===")
    print(f"Mensajes enviados correctamente: {response.success_count}")
    print(f"Mensajes fallidos: {response.failure_count}")

    for index, send_response in enumerate(response.responses):
        if send_response.success:
            print(f"Token {index + 1}: enviado correctamente.")
        else:
            print(
                f"Token {index + 1}: error -> "
                f"{send_response.exception}"
            )


def main():
    print("======================================")
    print("   ENVÍO DE NOTIFICACIÓN DE VENTA")
    print("======================================")

    sale_id = input("\nIngrese el sale_id: ").strip()

    if not sale_id:
        print("Debe ingresar un sale_id.")
        return

    try:
        db = initialize_firebase()

        # 1. Consultar sale
        sale_data = get_sale(db, sale_id)

        if sale_data is None:
            return

        user_id = sale_data.get("user_id")

        if not user_id:
            print("\nLa venta no contiene user_id.")
            return

        # 2. Consultar user
        user_data = get_user(db, user_id)

        if user_data is None:
            return

        # 3. Obtener tokens
        tokens = get_fcm_tokens(user_data)

        if not tokens:
            return
        send_notification(
            tokens,
            sale_id,
            sale_data,
        )

    except Exception as e:
        print("\n======================================")
        print("ERROR")
        print("======================================")
        print(e)


if __name__ == "__main__":
    main()