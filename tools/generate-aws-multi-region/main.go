package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"text/template"
)

// Config holds the region configuration.
type Config struct {
	Regions []string `json:"regions"`
}

func main() {
	// Define the CLI input flags.
	moduleDirPtr := flag.String("dir", "./", "Directory containing the Terraform module")
	regionsFilePtr := flag.String("regionsFile", "regions.json", "File containing the regions to generate Terraform files for")
	flag.Parse()

	fmt.Printf("Generating Terraform files for module in directory %s\n", *moduleDirPtr)
	fmt.Printf("Using regions from file %s\n", *regionsFilePtr)
	// Load regions from the specified file.
	config, err := loadRegions(*regionsFilePtr)
	if err != nil {
		fmt.Printf("Failed to load regions: %v\n", err)
		os.Exit(1)
	}

	// Load templates from the specified directory.
	templates, err := loadTemplates(filepath.Join(*moduleDirPtr, "templates"))
	if err != nil {
		fmt.Printf("Failed to load templates: %v\n", err)
		os.Exit(1)
	}

	// Generate Terraform files for each template.
	for _, tmpl := range templates {
		err = generateTerraformFile(*moduleDirPtr, tmpl, config)
		if err != nil {
			fmt.Printf("Failed to generate terraform file: %v\n", err)
			os.Exit(1)
		}
	}

	fmt.Println("Terraform files generated successfully.")
}

// loadRegions reads and parses the regions configuration file.
func loadRegions(filename string) (*Config, error) {
	data, err := os.ReadFile(filename)
	if err != nil {
		return nil, err
	}

	var config Config
	err = json.Unmarshal(data, &config)
	if err != nil {
		return nil, err
	}

	return &config, nil
}

// loadTemplates loads all templates from the specified directory.
func loadTemplates(dir string) ([]*template.Template, error) {
	var templates []*template.Template

	err := filepath.Walk(dir, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}

		if !info.IsDir() && strings.HasSuffix(info.Name(), ".tf.tmpl") {
			tmpl, err := template.ParseFiles(path)
			if err != nil {
				return err
			}
			templates = append(templates, tmpl)
		}

		return nil
	})

	if err != nil {
		return nil, err
	}

	return templates, nil
}

func generateTerraformFile(outDir string, tmpl *template.Template, config *Config) error {
	// Generate sanitized region names
	sanitizedRegions := make([]string, len(config.Regions))
	for i, region := range config.Regions {
		sanitizedRegions[i] = strings.ReplaceAll(region, "-", "_")
	}

	data := struct {
		Regions          []string
		SanitizedRegions []string
	}{
		Regions:          config.Regions,
		SanitizedRegions: sanitizedRegions,
	}

	// Define the output file name by removing ".tmpl" from the template name
	outputFileName := strings.TrimSuffix(filepath.Base(tmpl.Name()), ".tmpl")

	// Create the output file in the specified directory
	outputFilePath := filepath.Join(outDir, outputFileName)
	outputFile, err := os.Create(outputFilePath)
	if err != nil {
		return err
	}
	defer outputFile.Close()

	// Execute the template with the provided data
	err = tmpl.Execute(outputFile, data)
	if err != nil {
		return err
	}

	return nil
}
