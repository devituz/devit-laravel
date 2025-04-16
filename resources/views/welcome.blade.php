<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{ env('APP_NAME') }}</title>
    <link rel="stylesheet" href="{{asset('assets/css/devituz.css')}}">

</head>
<body>
<div class="container">
    <header>
        <h1>Welcome to Devituz</h1>
        <p>Your powerful Laravel application is ready to go!</p>
    </header>

    <section>
        <p>Explore the amazing features we offer and start building your application.</p>
        <button class="start-btn" onclick="startBuilding()">Getting Started</button>
    </section>

    <footer>
        <p><strong>Deployment has never been faster!</strong> Enjoy faster server setup and smooth performance with Devituz, giving you more time to build your dream app.</p>
        <p>Powered by <a href="http://devit.uz/">Devituz</a></p>
    </footer>
</div>

<script src="{{asset('assets/js/devituz.js')}}"></script>
</body>
</html>
