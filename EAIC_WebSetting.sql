<system.web>
  <httpRuntime maxRequestLength="1073741824" targetFramework="4.5.1" />
  <httpRuntime executionTimeout="3000" maxRequestLength="1073741824" targetFramework="4.5.1" requestValidationMode="2.0" />
</system.web>
<system.webServer>
  <security>
    <requestFiltering>
      <requestLimits maxAllowedContentLength="1073741824" />
    </requestFiltering>
  </security>
</system.webServer>

To summarise, to raise the file upload size to 50 MiB in IIS7 add the lines below in the correct section of the Web.config file:

  <system.webServer>
   <security>
      <requestFiltering>
        <requestLimits maxAllowedContentLength="52428800" />
      </requestFiltering>
    </security> 
  </system.webServer>


  <system.web>
    <httpRuntime maxRequestLength="51200" />
  </system.web>

