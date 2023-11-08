import { Kv, HandleRequest, HttpRequest, HttpResponse } from "@fermyon/spin-sdk"

export const handleRequest: HandleRequest = async function (request: HttpRequest): Promise<HttpResponse> {
  const store = Kv.open("foo")

  store.setJson("a", "bar")

  let body = store.getJson("a")

  return {
    status: 200,
    headers: { "content-type": "text/plain" },
    body: body
  }
}
