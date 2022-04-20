package tests

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestPrivateBucket(t *testing.T) {

	terraformOptions := &terraform.Options{
		TerraformDir: "../examples/private-bucket",
	}

	terraform.InitAndPlanWithExitCode(t, terraformOptions)

}
