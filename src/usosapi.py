class USOSAPIConnection():
    pass
    def __init__(self):
        pass
    #-----------------------------------------------------------------------------------
    def _generate_request_token(self):
        raise NotImplementedError

    def is_anonymous(self):
        raise NotImplementedError

    def is_authorized(self):
        raise NotImplementedError

    def test_connection(self):
        raise NotImplementedError

    def get_authorization_url(self):
        raise NotImplementedError

    def authorize_with_pin(self):
       raise NotImplementedError

    def get_access_data(self):
        raise NotImplementedError

    def set_access_data(self):
       raise NotImplementedError


    def get(self):
        raise NotImplementedError

    def logout(self):
        raise NotImplementedError

    def current_identity(self):
        raise NotImplementedError