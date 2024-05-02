I am writing all api calls here:
calls should look like http://srv27.mikr.us:20117/api?id=12456772&query1=a&query2=bar or 
http://srv27.mikr.us:20117/api?id=12456772&query1=223456
They can have up to 4 arguments. first is always id, then query(nr of query)
IMPORTANT! First, you need to create a session using http://srv27.mikr.us:20117/login. It will return your id, that
Should be kept secret. Then, when using other methods use this id.

"""
logging in/out:
---------
1. id, query1 = url, query2 empty ---- returns a string, url which has to be used to log in.
2. id, query1 = log_in, query2 = PIN (The value)  ---- logging the user in. 
returns dict {'AT', ATS'} with [access token] and [access token secret] used to resume the session, or 'N' if not succesful
3. id, query1 = resume, query2 [access token], query3 = [access token secret] ---- resumes the session.
returns 'Y' if was successful, and 'N' if not.
4. id, query1 = log_out, query2 empty ---- invalidates the access token.
---------
mail:
---------
5. id, query1 = send_email, query2 = [recepient], query3 = [subject], query4 = [content] ---- sends an email to
email adress given in [recepient], with subject given in [subject], and content given in [content].
returns 'Y' if message was send sucessfully, and 'N' if not.
6. id, query1 = get_emails ---- returns a list of mails send by user, where every element is a mail.
each element is a dict with: "id" : unique message id, "subject", "content", "date", 
and "to" - a list with two dicts:[ "email" - email of the recepient (or null), 
"user" - dict with information of the recepient: "first_name", "id", "last_name"]

example:
    {
        "content": "To jest test",
        "date": "2024-03-03 00:08:32",
        "id": "1780158",
        "subject": "Test",
        "to": [
            {
                "email": "oskar.kulinski@student.uj.edu.pl",
                "user": {
                    "first_name": "Oskar",
                    "id": "696969",
                    "last_name": "Kuliński"
                }
            }
        ]
    }

    




"""