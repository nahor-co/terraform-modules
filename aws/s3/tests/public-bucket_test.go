package tests

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestPublicBucket(t *testing.T) {

	terraformOptions := &terraform.Options{
		TerraformDir: "../examples/public-bucket",
	}

	terraform.InitAndPlanWithExitCode(t, terraformOptions)

}
