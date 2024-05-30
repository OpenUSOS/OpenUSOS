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
5. id, query1 = send_email, query2 = [recipient], query3 = [subject], query4 = [content] ---- sends an email to
email address given in [recipient], with subject given in [subject], and content given in [content].
returns 'Y' if message was send successfully, and 'N' if not.
6. id, query1 = get_emails ---- returns a list of mails send by user, where every element is a mail.
each element is a dict with: "id" : unique message id, "subject", "content", "date", 
and "to" - a list with two dicts:[ "email" - email of the recipient (or null), 
"user" - dict with information of the recipient: "first_name", "id", "last_name"]

example:
    {
        "content": "To jest test",
        "date": "2024-03-03 00:08:32",
        "id": "1780158",
        "subject": "Test",
        "to": [
            {
                "email": "example@example",
                "user": {
                    "first_name": "Jan",
                    "id": "696969",
                    "last_name": "Robak"
                }
            }
        ]
    }
---------
grades:
---------
7. id, query1 = get_grades ---- returns a list, containing dicts with details of grades: "date", "author",
"value", "name" (the name of a course, like 'Metody numeryczne'), "term", "class_type" (WYK, LAB).
---------
schedule:
---------
8. id, query1 = get_schedule, query2 = [start_date], query3 = [num_of_days] ---- returns a list of dicts,
with activities starting from [start date] (%Y-%m-%d format), including num_of_days days.
each activity contains: {"start_time", "end_time", "name" : {"pl", "en"}, "building_name", "room_number"}
---------
info:
---------
9. id, query1 = user_info ---- returns a dict with user information {"first_name", "last_name", "photo_url" (200x200), "email"}
---------
tests:
---------
10. id, query1 = get_tests ---- returns a list of dicts, each one with: "term_id" (eg. 22/23Z) and "courses".
"courses" is a list of the courses that took place during the term. it contains "name" (eg. ASD, sieci) and "tests".
"tests" is a list of all tests within one course. it contains "name", "description", "points" (of user) "points_max", and "exercises".
"exercises is a list of all exercises within one test. it contains "name", "description", "points" (of user) and "points_max".
---------
surveys:
---------
11. id, query1 = get_surveys ----- returns a list of surveys. each one is a dict containing:
"name", "id", "headline_html", "start_date", "end_date", lecturer: {"first_name", "last_name"}, "group": {"course_name","class_type"}
"questions". each question is a dict with: "id", "number", "display_text_html", "allow_comment",
"comment_length", "possible_answer". each possible answer is a dict containing: "id", "display_text_html".


12. id, query1 = answer_survey, query2 = [id of a query you answer], query3 = [answer]. answer the specific survey. answer should
be a JSON-formatted object, mapping question IDs to their answers, {"question1_id": {"answers": ["possible_answer1_id",
"possible_answer2_id", ...], "comment": "comment or null"}, "question2_id": ...}
Note, that all values of this objects are strings (because the IDs of possible answers are strings).
If comment should be left empty or the question does not allow comments, null has be passed in comment field.
----------
events:
----------
13. id, query1 = get_events, query2 = [from_date], query3 = [to_date], gets list of events beginning from and ending at.
each object in a list is a dict with "name" that has the name of a programme from which the event is, and "list"
with the list of the events. each event has a name, start_date, end_date, type, is_day_off (telling if it's a day of).
----------
news:
----------
14. id, query1 = get_news, query2 = [from_date], query3 = [start], query4 = [num] (100 <)
returns a dict with: 
[from date] - from where. [num] - how many should be returned
[start] - from which news to start.
"next_page" - true if there are more items. 
"total" - int showing how many items were matched
"items" a list of items. each item has just one field, "article" 
(kinda useless, but supposedly they can add more types of items in the future).
each article contains: name, author, publication_date, title, headline_html, content_html.


"""