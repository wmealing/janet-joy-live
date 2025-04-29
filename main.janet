#!/usr/bin/env janet
(use joy)
(import spork/netrepl)
(import halo2 :prefix "" :export true)

(setdyn :redef true)
(setdyn :dynamic-defs true)

# Layout
(defn app-layout [{:body body :request request}]
  (text/html
    (doctype :html5)
    [:html {:lang "en"}
     [:head
      [:title "my-joy-project"]
      [:meta {:charset "utf-8"}]
      [:meta {:name "viewport" :content "width=device-width, initial-scale=1"}]
      [:meta {:name "csrf-token" :content (csrf-token-value request)}]
      [:link {:href "/app.css" :rel "stylesheet"}]
      [:script {:src "/app.js" :defer ""}]]
     [:body
       body]]))

# Routes
(route :get "/" :homer)


(def heading-text "This changes live!!")

(defn homer [request]
  [:div {:class "tc"}
   [:h1 heading-text]
   [:h2 "Subheading"]
   [:p {:class "code"}]])


# Middleware
(defn app []
  (-> (handler)
      (layout app-layout)
      (with-csrf-token)
      (with-session)
      (extra-methods)
      (query-string)
      (body-parser)
      (json-body-parser)
      (server-error)
      (x-headers)
      (static-files)
      (not-found)
      (logger)))


(defn nb-server [handler port &opt host max-size]
  (default host "localhost")
  (default max-size 8192)

  (let [port (string port)
        socket (net/server host port)]

    (forever
      (when-let [conn (:accept socket)]
        (ev/call (connection-handler (handler) max-size) conn)
        (print "SLEEPING")
        (ev/sleep 0)
        ))))

# Server
(defn main [& args]

  # Start a repl
  (def repl-server
    (netrepl/server "127.0.0.1" "9365" (fiber/getenv (fiber/current))))


  (let [port (get args 1 (os/getenv "PORT" "9001"))
        host (get args 2 "localhost")]
    (nb-server app "8080")))
