from flask_wtf import Form
from wtforms import StringField, BooleanField
from wtforms.validators import DataRequired

class ControlForm(Form):
    command = StringField('command', validators=[DataRequired()])
    camera = StringField('camera', validators=[DataRequired()])
