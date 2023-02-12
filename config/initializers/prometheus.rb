require 'prometheus/client'

module Prometheus
  module Controller
    prometheus = Prometheus::Client.registry
    CLICK_LINKS_COUNTER = prometheus.counter(:click_links_counter, docstring: 'Counts link clicks', labels: [:token])
  end
end
