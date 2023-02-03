package validation

import (
	"os"
	"path/filepath"
	"strings"
	"testing"

	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"

	"github.com/stretchr/testify/require"
)

// TestValidateAllExamples recursively finds all modules and examples (by default) subdirectories in
// the repo and runs Terraform InitAndValidate on them to flush out missing variables, typos, unused vars, etc
func TestValidateAllExamples(t *testing.T) {
	t.Parallel()

	test_structure.ValidateAllTerraformModules(t, getValidationOptions(t))
}

/**
* Exclude non "example" directories to workaround Terraform modules requiring configuration_aliases.
**/
func getValidationOptions(t *testing.T) *test_structure.ValidationOptions {
	cwd, err := os.Getwd()
	require.NoError(t, err)

	// note: We exclude the following directories because they include non-trivial example files.
	// A ticket has been raised to address this.
	excludeDirs := []string{}
	includeDirs := []string{}

	opts, optsErr := test_structure.NewValidationOptions(filepath.Join(cwd, "../"), includeDirs, excludeDirs)
	require.NoError(t, optsErr)

	allDirs, readErr := test_structure.FindTerraformModulePathsInRootE(opts)
	require.NoError(t, readErr)

	filteredDirs := []string{}

	for _, v := range allDirs {
		if !strings.Contains(v, "example") {
			t.Logf("exclude: %s", v)
			filteredDirs = append(filteredDirs, v)
		}
	}

	opts.ExcludeDirs = filteredDirs

}
