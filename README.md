# LiveJoy

This project, **LiveJoy** demonstrates how to configure a Janet project with a live REPL that lets you interact with the [Joy](https://github.com/joy-framework/joy) web framework at runtime.

This setup allows you to change code in your editor and see updates reflected instantly in your running web server — no restarts, no rebuilds.

This same theory may also work for other janet projects, if you need this to work with another blocking tool, it could work for you too !

It might be possible to do this with other repls, but I've only tried emacs.

## 🔧 Getting Started

### 1. Clone the Repository


```sh
git clone https://github.com/wmealing/janet-joy-live.git
cd janet-joy-live
```

2. Run the REPL

From the shell:

```sh
jpm -l janet -d main.janet
```

This launches your application in interactive debugger mode via jpm.

⚠️ Note: You won't be able to interact with the REPL from the shell.

## 💻 Connect from Emacs

To interact with the live REPL, use Emacs with a-janet-spork-client:

Install and configure a-janet-spork-client in Emacs.

Load it in your Emacs session.

Within emacs run:

```elisp
M-x ajsc
```

This should connect to 127.0.0.1:9365 by default.

Now you can evaluate expressions in your editor and see changes live in your running Joy server.

## 🧪 Live Editing in Action

Open main.janet in your editor.

The server is started using a non-blocking handler that evaluates app on every HTTP request,
this is a slightly modified version of the one provided by the joy framework.

It is already in main.janet , but here it is for completion:

```clojure
(defn nb-server [handler port &opt host max-size]
  (default host "localhost")
  (default max-size 8192)

  (let [port (string port)
        socket (net/server host port)]

    (forever
      (when-let [conn (:accept socket)]
        (ev/call (connection-handler (handler) max-size) conn)
        (print "SLEEPING")
        (ev/sleep 0)))))
```

With the shell command still running , the Joy web app should be available at:

👉 http://localhost:8080/

### Example: Updating a Heading Live

In your editor, find this line:

```clojure
(def heading-text "This changes live!!")
```

Change the string value, put your cursor at the end of the expression, and run:

```
C-x C-e
```

This sends the new value to the REPL.

Now reload (ctrl+r ) the browser — you should see your new heading.

Example: Modify a apage renderer.

You can do the same with:

``` clojure
(defn home [request]
  ...)
```
Change the function body, evaluate it in Emacs, and refresh the page.

🔮 The future

It might be possible to force a state change and do live javascript reloads, although I'm
not sure how to do that, but it probably uses some kind of websocket and algorithm.  I think
shadow-cljs does it, so it must be possible.  PR's welcome !

🌀 Why LiveJoy?

- Rapid feedback loop

- Explore Joy at runtime

- Edit and test route handlers live

- Great for prototyping or learning Joy
