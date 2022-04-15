from flask import Flask, render_template

app = Flask(__name__,
            static_folder="/media",
            template_folder="/via/via-3.0.11")


@app.route('/')
@app.route('/index')
def index():
    return 'Hello world!'


@app.route('/via_template')
def via():
    return render_template("via_video_annotator.html")


if __name__ == '__main__':
    app.run()
