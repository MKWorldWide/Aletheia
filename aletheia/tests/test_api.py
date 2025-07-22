from aletheia.run import app

def test_endpoints_present() -> None:
    routes = {route.path for route in app.routes}
    assert "/fact" in routes
    assert "/truth" in routes
    assert "/ask" in routes
