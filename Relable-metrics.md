Your current configuration is **already very close** to correctly tagging the metrics with the host name. You just need to ensure the `nodename` label, which is often used by the standard Prometheus Node Exporter dashboard, is also set.

Here are the required changes to your Alloy config file:

### 1\. Update `discovery.relabel "integrations_node_exporter"`

You need to add a second rule to explicitly replace the `nodename` label, which often defaults to the container ID or an internal hostname.

In the `discovery.relabel "integrations_node_exporter"` block, **add the following rule**:

```alloy
// This block relabels metrics coming from node_exporter to add standard labels
discovery.relabel "integrations_node_exporter" {
    targets = prometheus.exporter.unix.integrations_node_exporter.targets

    rule {
        // Set the instance label to the hostname of the machine
        target_label = "instance"
        replacement  = constants.hostname
    }

    // ⭐ ADD THIS NEW RULE ⭐
    rule {
        // Set the nodename label to the hostname of the machine for dashboard compatibility
        target_label = "nodename"
        replacement  = constants.hostname
    }
    // ⭐ END OF NEW RULE ⭐

    rule {
        // Set a standard job name for all node_exporter metrics
        target_label = "job"
        replacement = "integrations/node_exporter"
    }
}
```

-----

### 2\. Verify `prometheus.scrape "integrations_node_exporter"`

This block is **already correctly configured** to use the output of the relabeling step, meaning the new `instance` and `nodename` labels are applied *before* the metrics are sent to Prometheus.

```alloy
// Define how to scrape metrics from the node_exporter
prometheus.scrape "integrations_node_exporter" {
    scrape_interval = "15s"
    // targets = discovery.relabel.integrations_node_exporter.output <--- This is correct
    targets = discovery.relabel.integrations_node_exporter.output
    // Send the scraped metrics to the relabeling component
    forward_to = [prometheus.remote_write.local.receiver]
}
```

**In summary:** By adding the rule to replace the **`nodename`** label with **`constants.hostname`**, your metrics will be consistently tagged with the host's name, resolving the issue with ephemeral container IDs in your Node Dashboard. This works because the `constants.hostname` value, when Alloy runs in a container with proper host networking, typically resolves to the actual host's hostname.