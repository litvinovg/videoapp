# coding=utf-8
from app import app
from flask import render_template, flash, redirect
from app import streaming
from .forms import ControlForm
@app.route('/index', methods=['GET', 'POST'])
@app.route('/', methods=['GET', 'POST'])

def index():
    form = ControlForm()
    if form.validate_on_submit():
      if form.command.data == "start":
        streaming.start(form.camera.data)
      if form.command.data == "stop":
        streaming.stop(form.camera.data)
      return redirect('/')
    return render_template('index.html', cameras=app.cameras, streaming=streaming,form=form)
