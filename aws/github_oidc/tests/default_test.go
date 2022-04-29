package tests

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestPlan(t *testing.T) {

	terraformOptions := &terraform.Options{
		TerraformDir: "../examples",
	}

	terraform.InitAndPlanWithExitCode(t, terraformOptions)

}
