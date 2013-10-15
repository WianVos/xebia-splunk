# splunk client configuration class
class splunk::client::config (
  $splk_admin_password  = $splunk::splk_admin_password,
  $splk_adminport       = $splunk::splk_adminport,
  $splk_apps            = $splunk::splk_apps) {

  splunk_login { 'admin': password => $splk_admin_password }
  create_resources(splunk_app, $splk_apps)
}