from checkov.common.models.enums import CheckResult, CheckCategories
from checkov.terraform.checks.resource.base_resource_check import BaseResourceCheck

class SecurityGroupNoOpenSSH(BaseResourceCheck):
    def __init__(self):
        name = "KWAN: Ensure Security Group does not expose SSH (port 22) to world"
        id = "CKV_CUSTOM_003"
        supported_resources = ["aws_security_group"]
        categories = [CheckCategories.NETWORKING]
        super().__init__(name=name, id=id, categories=categories, supported_resources=supported_resources)
 

    def scan_resource_conf(self, conf):
        ingress_rules = conf.get("ingress", [])
        for rule in ingress_rules:
            if isinstance(rule, dict):
                from_port = rule.get("from_port", [None])[0]
                to_port = rule.get("to_port", [None])[0]
                cidr_blocks = rule.get("cidr_blocks", [[]])[0]

                if from_port is not None and to_port is not None:
                    if from_port <= 8080 <= to_port and "0.0.0.0/0" in cidr_blocks:
                        return CheckResult.FAILED
        return CheckResult.PASSED

check = SecurityGroupNoOpenSSH()