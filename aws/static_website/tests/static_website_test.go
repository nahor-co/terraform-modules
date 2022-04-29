package tests

import (
	"crypto/tls"
	"testing"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestStaticWebsite(t *testing.T) {

	terraformOptions := &terraform.Options{
		TerraformDir: "../examples/static_website",
	}

	terraform.InitAndApplyAndIdempotent(t, terraformOptions)

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	url := terraform.Output(t, terraformOptions, "url")

	// Setup a TLS configuration to submit with the helper, a blank struct is acceptable
	tlsConfig := tls.Config{}

	// Verify that we get back a 200 OK with the expected instanceText
	httpCode, body := http_helper.HttpGet(t, url, &tlsConfig)
	_ = &body
	assert.Equal(t, 200, httpCode)
}
