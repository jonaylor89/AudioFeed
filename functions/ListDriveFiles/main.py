import pickle
import os
from googleapiclient.discovery import build
from google.oauth2 import service_account


def main(request):

    FILETYPE = "audio/mpeg"

    service = build("drive", "v3")

    results = (
        service.files()
        .list(fields="files(id, name)", q=f"mimeType='{FILETYPE}'")
        .execute()
    )

    items = results.get("files", [])

    item_dict = map(lambda x: {"name": x["name"], "id": x["id"]}, items)

    return {"files": list(item_dict)}
