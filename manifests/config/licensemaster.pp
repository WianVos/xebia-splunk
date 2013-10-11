#class splunk::config::licensemaster
#
# this class configures the splunk licensemanager
class splunk::config::licensemaster(
$splk_lm_licenses = $splunk::splk_lm_licenses ){

  create_resources(splunk_license, $splk_lm_licenses)
}