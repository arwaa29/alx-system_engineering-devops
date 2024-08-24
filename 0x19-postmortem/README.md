# Postmortem: API Service Outage on August 22, 2024

## Issue Summary

**Duration:**  
August 22, 2024, 14:00 to 16:30 UTC (2 hours and 30 minutes)

**Impact:**  
The API service responsible for processing payment transactions experienced severe degradation. Approximately 75% of API requests failed, leading to incomplete transactions for users attempting to make payments. This impacted around 60% of our user base, with the remaining 40% experiencing delayed responses. During this period, revenue generation was significantly affected.

**Root Cause:**  
A misconfiguration in the load balancer caused uneven distribution of traffic, leading to server overload on a subset of backend instances.

## Timeline

- **14:00 UTC:** Issue detected by automated monitoring system, which triggered an alert due to a sudden spike in API error rates.
- **14:05 UTC:** On-call engineer received the alert and began investigating. Initial suspicion was a database connectivity issue due to recent updates.
- **14:15 UTC:** Database team was contacted to check for any anomalies, but no issues were found.
- **14:30 UTC:** Network operations team was engaged to investigate potential network latency or packet loss.
- **14:45 UTC:** Network diagnostics returned normal, leading the team to suspect a potential code regression.
- **15:00 UTC:** Application logs were thoroughly reviewed; no recent deployments or changes were identified as the cause.
- **15:20 UTC:** The focus shifted to infrastructure. Load balancer logs indicated uneven distribution of traffic.
- **15:30 UTC:** Load balancer configuration was reviewed and a misconfiguration was identified. Several backend instances were receiving disproportionately high traffic.
- **15:40 UTC:** Load balancer configuration was corrected, and traffic was evenly redistributed.
- **16:00 UTC:** Traffic began to normalize, and error rates dropped.
- **16:30 UTC:** Issue fully resolved, and all services were operating normally.

## Root Cause and Resolution

**Root Cause:**  
The load balancer was misconfigured during routine maintenance the previous night. Specifically, a weight parameter was incorrectly set, causing it to send the majority of traffic to a small subset of backend instances. These instances became overloaded, resulting in high response times and increased error rates. The automated scaling did not trigger as expected because the load balancer incorrectly reported the overall traffic as balanced.

**Resolution:**  
The configuration error in the load balancer was corrected, and traffic was immediately redistributed across all backend instances. This alleviated the overload, normalizing response times and reducing error rates.

## Corrective and Preventative Measures

**Improvements:**  
- **Load Balancer Configuration Review:** Implement a mandatory peer review process for all load balancer configuration changes.
- **Monitoring Enhancements:** Improve monitoring to detect uneven traffic distribution, triggering faster alerts when backend instances are overloaded.
- **Automatic Scaling Validation:** Enhance the automated scaling mechanism to better account for uneven traffic distribution and trigger scaling events more reliably.

**Tasks:**
1. **Implement peer review for load balancer configuration changes**  
   *Due: August 29, 2024*

2. **Add monitoring alerts to detect uneven traffic distribution across backend instances**  
   *Due: September 5, 2024*

3. **Audit and update the automated scaling rules to ensure they account for potential misconfigurations in traffic distribution**  
   *Due: September 12, 2024*

4. **Conduct a postmortem review training session to share learnings from this incident with the engineering and operations teams**  
   *Due: September 19, 2024*

---

This incident has highlighted the importance of comprehensive configuration checks and better monitoring. By implementing these corrective actions, we aim to prevent similar issues from occurring in the future.
