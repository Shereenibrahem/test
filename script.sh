#!/bin/bash -

top3() {
  awk '
    # For each service, compute a running total duration
    ($2 == "start") {
      current_run[$3] = $1;
    };
    ($2 == "finish") {
      previous = total_duration[$3] + 0.0;
      total_duration[$3] = previous + $1 - current_run[$3];
    };
    # And finally, return the top 3 results from the durations collected
    END {
      for (i=0; i<3; i++) {
        result[i ",service"] = "";
        result[i ",duration"] = 0.0;
      };
      for (service in total_duration) {
        duration = total_duration[service];
        for (i=0; i<3; i++) {
          if (duration > result[i ",duration"]) {
            result[i ",service"] = service;
            result[i ",duration"] = duration;
            break;
          }
        }
      }
      for (i=0; i<3; i++) {
        if (result[i ",service"] != "") {
          print(result[i ",service"], result[i ",duration"]);
        }
    }
  }'
}

cat "$@" | top3
