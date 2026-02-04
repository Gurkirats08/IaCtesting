# Existing Log Analytics workspace
data "azurerm_log_analytics_workspace" "law" {
  name                = var.law_name
  resource_group_name = var.law_rg_name
}

#Existing Data Collection endpoint 
data "azurerm_monitor_data_collection_endpoint" "this" {
  name                = var.dce_name             
  resource_group_name = var.dce_rg_name          
}

# Data collection Rule
resource "azurerm_monitor_data_collection_rule" "this" {
  name                        = var.dcr_name
  resource_group_name         = var.dcr_rg_name
  location                    = var.dcr_rg_location
  data_collection_endpoint_id = data.azurerm_monitor_data_collection_endpoint.this.id

  destinations {
    log_analytics {
      workspace_resource_id = data.azurerm_log_analytics_workspace.law.id
      name                  = var.destination_logworkspace
    }
  }

  data_flow {
    streams      = var.data_flow_streams
    destinations = [var.destination_logworkspace]
  }

//   data_sources {
//     performance_counter {
//       streams                       =  var.datasource_perfcounter 
//       sampling_frequency_in_seconds = 60
//       counter_specifiers            = var.datasource_perfCounterSpecifiers
//       name                          = var.win_perfcounter_name
//     }

//      windows_event_log {
//         streams        = var.win_event_log_stream
//         x_path_queries = var.win_path_Query
//         name           = var.win_log_name
//       }

//     syslog {
//       facility_names   = ["*"]
//         log_levels     = ["*"]
//         name           = var.linux_log_name
//         streams        = var.linux_event_log_stream
//       }

// }  

  data_sources {
      # Windows-specific data sources
      dynamic "performance_counter" {
        for_each = var.os_type == "windows" ? [1] : []
        content {
          streams                       = var.datasource_perfcounter
          sampling_frequency_in_seconds = 60
          counter_specifiers            = var.datasource_perfCounterSpecifiers
          name                          = var.win_perfcounter_name
        }
      }

      dynamic "windows_event_log" {
        for_each = var.os_type == "windows" ? [1] : []
        content {
          streams        = var.win_event_log_stream
          x_path_queries = var.win_path_Query
          name           = var.win_log_name
        }
      }

      # Linux-specific data sources
      dynamic "syslog" {
        for_each = var.os_type == "linux" ? [1] : []
        content {
          facility_names = ["*"]
          log_levels     = ["*"]
          name           = var.linux_log_name
          streams        = var.linux_event_log_stream
        }
      }
    }
  
  description = "data collection rule "
  tags        = var.tags
}