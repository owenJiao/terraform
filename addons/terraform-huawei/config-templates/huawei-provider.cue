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
				region:   parameter.HUAWEI_REGION
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

        creds1: "accessKey: " + parameter.HUAWEI_SECRET_ID
        creds2: "secretKey: " + parameter.HUAWEI_SECRET_KEY

	l: {
		"config.oam.dev/catalog":  "velacore-config"
		"config.oam.dev/type":     "terraform-provider"
		"config.oam.dev/provider": "terraform-huawei"
	}

	parameter: {
		//+usage=The name of Terraform Provider for Tencent Cloud, default is `default`
		name: *"default" | string
		//+usage=Get TENCENTCLOUD_SECRET_ID per this guide https://cloud.tencent.com/document/product/1213/67093
		HUAWEI_SECRET_ID: string
		//+usage=Get TENCENTCLOUD_SECRET_KEY per this guide https://cloud.tencent.com/document/product/1213/67093
		HUAWEI_SECRET_KEY: string
		//+usage=Get TENCENTCLOUD_REGION by picking one RegionId from Tencent Cloud region list https://cloud.tencent.com/document/api/1140/40509#.E5.9C.B0.E5.9F.9F.E5.88.97.E8.A1.A8
		HUAWEI_REGION: string
	}
}
