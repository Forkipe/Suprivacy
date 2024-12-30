import Foundation

struct TemplatesSupport {
    let templates: [String: String] = [
        "Template Support 1": """
<html>
    <head>
        <style type="text/css">
            @import url(https://fonts.googleapis.com/css?family=Roboto:400,300,600,400italic);
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                -webkit-box-sizing: border-box;
                -moz-box-sizing: border-box;
                -webkit-font-smoothing: antialiased;
                -moz-font-smoothing: antialiased;
                -o-font-smoothing: antialiased;
                font-smoothing: antialiased;
                text-rendering: optimizeLegibility;
            }
            
            body {
                font-family: "Roboto", Helvetica, Arial, sans-serif;
                font-weight: 100;
                font-size: 12px;
                line-height: 30px;
                color: #777;
                background: #FFFFFF;
            }
            
            .container {
                max-width: 400px;
                width: 100%;
                margin: 0 auto;
                position: relative;
            }
            
            #contact input[type="text"],
            #contact input[type="email"],
            #contact input[type="tel"],
            #contact textarea,
            #contact button[type="submit"] {
                font: 400 12px/16px "Roboto", Helvetica, Arial, sans-serif;
            }
            
            #contact {
                background: #F9F9F9;
                padding: 25px;
                margin: 150px 0;
                box-shadow: 0 0 20px 0 rgba(0, 0, 0, 0.2), 0 5px 5px 0 rgba(0, 0, 0, 0.24);
            }
            
            #contact h3 {
                display: block;
                font-size: 30px;
                font-weight: 300;
                margin-bottom: 10px;
            }
            
            #contact h4 {
                margin: 5px 0 15px;
                display: block;
                font-size: 13px;
                font-weight: 400;
            }
            
            fieldset {
                border: medium none !important;
                margin: 0 0 10px;
                min-width: 100%;
                padding: 0;
                width: 100%;
            }
            
            #contact input[type="text"],
            #contact input[type="email"],
            #contact input[type="tel"],
            #contact textarea {
                width: 100%;
                border: 1px solid #ccc;
                background: #FFF;
                margin: 0 0 5px;
                padding: 10px;
            }
            
            #contact input[type="text"]:hover,
            #contact input[type="email"]:hover,
            #contact input[type="tel"]:hover,
            #contact textarea:hover {
                -webkit-transition: border-color 0.3s ease-in-out;
                -moz-transition: border-color 0.3s ease-in-out;
                transition: border-color 0.3s ease-in-out;
                border: 1px solid #aaa;
            }
            
            #contact textarea {
                height: 100px;
                max-width: 100%;
                resize: none;
            }
            
            #contact button[type="submit"] {
                cursor: pointer;
                width: 100%;
                border: none;
                background: #1218DB;
                color: #FFF;
                margin: 0 0 5px;
                padding: 10px;
                font-size: 15px;
            }
            
            #contact button[type="submit"]:hover {
                background: #4C65E0;
                -webkit-transition: background 0.3s ease-in-out;
                -moz-transition: background 0.3s ease-in-out;
                transition: background-color 0.3s ease-in-out;
            }
            
            #contact button[type="submit"]:active {
                box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.5);
            }
            
            .copyright {
                text-align: center;
            }
            
            #contact input:focus,
            #contact textarea:focus {
                outline: 0;
                border: 1px solid #aaa;
            }
            
            ::-webkit-input-placeholder {
                color: #888;
            }
            
            :-moz-placeholder {
                color: #888;
            }
            
            ::-moz-placeholder {
                color: #888;
            }
            
            :-ms-input-placeholder {
                color: #888;
            }
        </style>
    </head>
    
    <div class="container">
        <form id="contact" action="mailto:{{mail}}" method="post">
            <h3>{{appName}} Support Form</h3>
            <h4>Contact us if you have trouble with our application</h4>
            <fieldset>
                <input placeholder="Your name" type="text" tabindex="1" required autofocus>
            </fieldset>
            <fieldset>
                <input placeholder="Your Email Address" type="email" tabindex="2" required>
            </fieldset>
            <fieldset>
                <input placeholder="Your Phone Number (optional)" type="tel" tabindex="3" optional>
            </fieldset>
            <fieldset>
                <textarea placeholder="Type your message here...." tabindex="5" required></textarea>
            </fieldset>
            <fieldset>
                <button name="submit" type="submit" id="contact-submit" data-submit="...Sending">Submit</button>
            </fieldset>
        </form>
    </div>
""",
        "Template Support 2" : """
<html>
    <head>
        <style>
            /* Template 1: Minimalistic */
            body {
                font-family: Arial, sans-serif;
                background-color: #f2f2f2;
                margin: 0;
                padding: 0;
            }

            .container {
                width: 100%;
                max-width: 500px;
                margin: 50px auto;
                background: #ffffff;
                border-radius: 10px;
                padding: 20px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            }

            form {
                display: flex;
                flex-direction: column;
            }

            h3 {
                color: #333333;
                margin-bottom: 10px;
            }

            h4 {
                color: #777;
                margin-bottom: 20px;
                font-size: 14px;
            }

            input, textarea, button {
                margin-bottom: 15px;
                padding: 10px;
                font-size: 14px;
                border: 1px solid #ccc;
                border-radius: 5px;
            }

            button {
                background-color: #1218DB;
                color: white;
                border: none;
                cursor: pointer;
            }

            button:hover {
                background-color: #4C65E0;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <form action="mailto:{{mail}}" method="post">
                <h3>{{appName}} Support Form</h3>
                <h4>Contact us if you have trouble with our application</h4>
                <input placeholder="Your Name" type="text" required>
                <input placeholder="Your Email Address" type="email" required>
                <input placeholder="Your Phone Number (optional)" type="tel">
                <textarea placeholder="Type your message here..." required></textarea>
                <button type="submit">Submit</button>
            </form>
        </div>
    </body>
</html>
""",
        "Template Support 3" : """
<html>
    <head>
        <style>
            /* Template 2: Modern Gradient */
            body {
                font-family: 'Roboto', sans-serif;
                background: linear-gradient(135deg, #667eea, #764ba2);
                margin: 0;
                padding: 0;
            }

            .container {
                max-width: 400px;
                margin: 50px auto;
                background: #ffffff;
                border-radius: 10px;
                padding: 30px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
            }

            form {
                display: flex;
                flex-direction: column;
            }

            h3 {
                color: #764ba2;
                margin-bottom: 10px;
                text-align: center;
            }

            h4 {
                color: #333333;
                margin-bottom: 20px;
                text-align: center;
            }

            input, textarea, button {
                margin-bottom: 20px;
                padding: 12px;
                font-size: 14px;
                border: 1px solid #ddd;
                border-radius: 5px;
            }

            button {
                background: linear-gradient(135deg, #667eea, #764ba2);
                color: white;
                border: none;
                cursor: pointer;
            }

            button:hover {
                background: linear-gradient(135deg, #764ba2, #667eea);
            }
        </style>
    </head>
    <body>
        <div class="container">
            <form action="mailto:{{mail}}" method="post">
                <h3>{{appName}} Support</h3>
                <h4>Need help? Contact us below</h4>
                <input placeholder="Your Name" type="text" required>
                <input placeholder="Your Email" type="email" required>
                <textarea placeholder="Your Message" required></textarea>
                <button type="submit">Send Message</button>
            </form>
        </div>
    </body>
</html>
""",
        "Template Support 4" : """
<html>
    <head>
        <style>
            /* Template 3: Dark Mode */
            body {
                font-family: 'Arial', sans-serif;
                background-color: #121212;
                color: #E0E0E0;
                margin: 0;
                padding: 0;
            }

            .container {
                max-width: 400px;
                margin: 50px auto;
                background-color: #1E1E1E;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.5);
            }

            form {
                display: flex;
                flex-direction: column;
            }

            h3 {
                color: #BB86FC;
                margin-bottom: 15px;
                text-align: center;
            }

            h4 {
                color: #B0B0B0;
                margin-bottom: 20px;
                text-align: center;
            }

            input, textarea, button {
                margin-bottom: 15px;
                padding: 10px;
                font-size: 14px;
                border: 1px solid #333;
                border-radius: 5px;
                background-color: #2C2C2C;
                color: #E0E0E0;
            }

            button {
                background-color: #BB86FC;
                border: none;
                color: #121212;
                font-weight: bold;
                cursor: pointer;
            }

            button:hover {
                background-color: #985EFF;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <form action="mailto:{{mail}}" method="post">
                <h3>{{appName}} Support</h3>
                <h4>We’re here to help</h4>
                <input placeholder="Your Name" type="text" required>
                <input placeholder="Your Email" type="email" required>
                <textarea placeholder="Describe your issue..." required></textarea>
                <button type="submit">Send Message</button>
            </form>
        </div>
    </body>
</html>
""",
        "Template Support 5" : """
<html>
    <head>
        <style>
            /* Template 4: Playful */
            body {
                font-family: 'Comic Sans MS', sans-serif;
                background: #FFEB3B;
                margin: 0;
                padding: 0;
            }

            .container {
                max-width: 400px;
                margin: 50px auto;
                background: #FFFFFF;
                border: 2px dashed #FF9800;
                border-radius: 15px;
                padding: 20px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.15);
            }

            form {
                display: flex;
                flex-direction: column;
            }

            h3 {
                color: #FF5722;
                margin-bottom: 10px;
                text-align: center;
            }

            h4 {
                color: #9E9E9E;
                margin-bottom: 20px;
                text-align: center;
            }

            input, textarea, button {
                margin-bottom: 15px;
                padding: 12px;
                font-size: 14px;
                border: 1px solid #FF9800;
                border-radius: 5px;
            }

            button {
                background: #FF5722;
                color: white;
                border: none;
                cursor: pointer;
            }

            button:hover {
                background: #FF3D00;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <form action="mailto:{{mail}}" method="post">
                <h3>{{appName}} Support</h3>
                <h4>Let us know what’s up!</h4>
                <input placeholder="Your Name" type="text" required>
                <input placeholder="Your Email" type="email" required>
                <textarea placeholder="Your Message" required></textarea>
                <button type="submit">Submit</button>
            </form>
        </div>
    </body>
</html>
""",
        "Template Support 6" : """
<html>
<head>
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background-color: #f4f4f4;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .container {
            background-color: white;
            border-radius: 10px;
            border: 1px solid #ddd;
            padding: 25px;
            width: 100%;
            max-width: 450px;
        }

        h3 {
            font-size: 30px;
            text-align: center;
            margin-bottom: 15px;
        }

        h4 {
            font-size: 14px;
            text-align: center;
            color: #888;
            margin-bottom: 20px;
        }

        input, textarea {
            width: 100%;
            padding: 12px;
            margin-bottom: 10px;
            border-radius: 8px;
            border: 1px solid #ddd;
            font-size: 14px;
        }

        button {
            width: 100%;
            padding: 12px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
        }

        button:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <div class="container">
        <form id="contact" action="mailto:{{mail}}" method="post">
            <h3>{{appName}} Support Form</h3>
            <h4>Let us know how we can help you</h4>
            <input placeholder="Your name" type="text" tabindex="1" required autofocus>
            <input placeholder="Your Email Address" type="email" tabindex="2" required>
            <input placeholder="Your Phone Number (optional)" type="tel" tabindex="3">
            <textarea placeholder="Type your message here..." tabindex="5" required></textarea>
            <button name="submit" type="submit" id="contact-submit">Submit</button>
        </form>
    </div>
</body>
</html>
""",
        "Template Support 7" : """
<html>
<head>
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background: url('your-image-url.jpg') no-repeat center center fixed;
            background-size: cover;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .container {
            background-color: rgba(255, 255, 255, 0.8);
            padding: 30px;
            border-radius: 8px;
            width: 100%;
            max-width: 450px;
        }

        h3 {
            font-size: 28px;
            text-align: center;
            margin-bottom: 15px;
        }

        h4 {
            font-size: 15px;
            text-align: center;
            color: #555;
            margin-bottom: 20px;
        }

        input, textarea {
            width: 100%;
            padding: 12px;
            margin-bottom: 15px;
            border-radius: 5px;
            border: 1px solid #ddd;
            font-size: 14px;
        }

        button {
            width: 100%;
            padding: 12px;
            background-color: #0066cc;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
        }

        button:hover {
            background-color: #004d99;
        }
    </style>
</head>
<body>
    <div class="container">
        <form id="contact" action="mailto:{{mail}}" method="post">
            <h3>{{appName}} Support</h3>
            <h4>We’re here to assist you!</h4>
            <input placeholder="Your name" type="text" tabindex="1" required autofocus>
            <input placeholder="Your Email Address" type="email" tabindex="2" required>
            <input placeholder="Your Phone Number (optional)" type="tel" tabindex="3">
            <textarea placeholder="Type your message here..." tabindex="5" required></textarea>
            <button name="submit" type="submit" id="contact-submit">Submit</button>
        </form>
    </div>
</body>
</html>
""",
        "Template Support 8" : """
<html>
<head>
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background-color: #f7f7f7;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .container {
            background-color: #ffffff;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
            padding: 40px;
            width: 100%;
            max-width: 450px;
        }

        h3 {
            font-size: 32px;
            text-align: center;
            margin-bottom: 15px;
        }

        h4 {
            font-size: 16px;
            text-align: center;
            color: #555;
            margin-bottom: 25px;
        }

        input, textarea {
            width: 100%;
            padding: 12px;
            margin-bottom: 15px;
            border-radius: 8px;
            border: 1px solid #ccc;
            font-size: 14px;
        }

        button {
            width: 100%;
            padding: 12px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
        }

        button:hover {
            background-color: #218838;
        }
    </style>
</head>
<body>
    <div class="container">
        <form id="contact" action="mailto:{{mail}}" method="post">
            <h3>{{appName}} Support Form</h3>
            <h4>Need help? We're here to assist!</h4>
            <input placeholder="Your name" type="text" tabindex="1" required autofocus>
            <input placeholder="Your Email Address" type="email" tabindex="2" required>
            <input placeholder="Your Phone Number (optional)" type="tel" tabindex="3">
            <textarea placeholder="Type your message here..." tabindex="5" required></textarea>
            <button name="submit" type="submit" id="contact-submit">Submit</button>
        </form>
    </div>
</body>
</html>
""",
        "Template Support 9" : """
<html>
<head>
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background-color: #e3e3e3;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .container {
            background-color: white;
            padding: 25px;
            border-radius: 8px;
            width: 100%;
            max-width: 450px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        h3 {
            font-size: 28px;
            text-align: center;
            margin-bottom: 15px;
        }

        h4 {
            font-size: 14px;
            text-align: center;
            color: #777;
            margin-bottom: 25px;
        }

        .input-container {
            position: relative;
            margin-bottom: 15px;
        }

        input, textarea {
            width: 100%;
            padding: 12px;
            font-size: 14px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }

        input:focus, textarea:focus {
            outline: none;
            border-color: #0066cc;
        }

        label {
            position: absolute;
            top: 0;
            left: 12px;
            font-size: 14px;
            color: #777;
            transition: 0.3s;
        }

        input:focus + label, textarea:focus + label {
            top: -18px;
            left: 12px;
            font-size: 12px;
            color: #0066cc;
        }

        button {
            width: 100%;
            padding: 12px;
            background-color: #0066cc;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
        }

        button:hover {
            background-color: #004d99;
        }
    </style>
</head>
<body>
    <div class="container">
        <form id="contact" action="mailto:{{mail}}" method="post">
            <h3>{{appName}} Support</h3>
            <h4>Let us know how we can help you</h4>
            <div class="input-container">
                <input placeholder="Your name" type="text" tabindex="1" required autofocus>
               
            </div>
            <div class="input-container">
                <input placeholder="Your Email Address" type="email" tabindex="2" required>
               
            </div>
            <div class="input-container">
                <input placeholder="Your Phone Number (optional)" type="tel" tabindex="3">
               
            </div>
            <div class="input-container">
                <textarea placeholder="Type your message here..." tabindex="5" required></textarea>
               
            </div>
            <button name="submit" type="submit" id="contact-submit">Submit</button>
        </form>
    </div>
</body>
</html>
"""
    ]
}
