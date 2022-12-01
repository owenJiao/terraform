import "strings"

metadata: {
	name:        "terraform-huawei"
	alias:       "Terraform Provider for Huawei Cloud"
	description: "Terraform Provider for Huawei Cloud"
	sensitive:   true
	scope:       "system"
}

template: {
	outputs: {
		"provider": {
			apiVersion: "terraform.core.oam.dev/v1beta1"
			kind:       "Provider"
			metadata: {
				name:      parameter.name
				namespace: "default"
				labels:    l
			}
			spec: {
				provider: "huawei"
				region:   parameter.HUAWEICLOUD_REGION
				credentials: {
					source: "Secret"
					secretRef: {
						name:      context.name
						namespace: context.namespace
						key:       "credentials"
					}
				}
			}
		}
	}
	output: {
		apiVersion: "v1"
		kind:       "Secret"
		metadata: {
			name:      context.name
			namespace: context.namespace
			labels:    l
		}
		type: "Opaque"
		stringData: credentials: strings.Join([creds1, creds2], "\n")
	}

        creds1: "accessKey: " + parameter.HUAWEICLOUD_ACCESS_KEY
        creds2: "secretKey: " + parameter.HUAWEICLOUD_SECRET_KEY

	l: {
		"config.oam.dev/catalog":  "velacore-config"
		"config.oam.dev/type":     "terraform-provider"
		"config.oam.dev/provider": "terraform-huawei"
	}

	parameter: {
		//+usage=The name of Terraform Provider for Huawei Cloud, default is `default`
		name: *"default" | string
		//+usage=Get HUAWEICLOUD_ACCESS_KEY per this guide https://support.huaweicloud.com/productdesc-iam/iam_01_0040.html
		HUAWEICLOUD_ACCESS_KEY: string
		//+usage=Get HUAWEICLOUD_SECRET_KEY per this guide https://support.huaweicloud.com/productdesc-iam/iam_01_0040.html
		HUAWEICLOUD_SECRET_KEY: string
		//+usage=Get HUAWEICLOUD_REGION  by picking one RegionId from Huawei Cloud region list https://developer.huaweicloud.com/endpoint?all
		HUAWEICLOUD_REGION: string
	}
}
