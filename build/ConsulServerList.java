/*
 * Copyright 2013-2015 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.springframework.cloud.consul.discovery;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import com.ecwid.consul.v1.ConsulClient;
import com.ecwid.consul.v1.QueryParams;
import com.ecwid.consul.v1.Response;
import com.ecwid.consul.v1.health.model.Check;
import com.ecwid.consul.v1.health.model.HealthService;
import com.netflix.client.config.IClientConfig;
import com.netflix.loadbalancer.AbstractServerList;

/**
 * @author Spencer Gibb
 */
public class ConsulServerList extends AbstractServerList<ConsulServer> {

    private final ConsulClient client;
    private final ConsulDiscoveryProperties properties;

    private String serviceId;

    public ConsulServerList(ConsulClient client, ConsulDiscoveryProperties properties) {
        this.client = client;
        this.properties = properties;
    }

    @Override
    public void initWithNiwsConfig(IClientConfig clientConfig) {
        this.serviceId = clientConfig.getClientName();
    }

    @Override
    public List<ConsulServer> getInitialListOfServers() {
        return getServers();
    }

    @Override
    public List<ConsulServer> getUpdatedListOfServers() {
        return getServers();
    }

    private List<ConsulServer> getServers() {
        if (this.client == null) {
            return Collections.emptyList();
        }

        //不再请求consul, 直接使用service_id 当做address返回
        /*
        String tag = getTag(); // null is ok
         */
        /*
        Response<List<HealthService>> response = this.client.getHealthServices(
                this.serviceId, tag, this.properties.isQueryPassing(),
                QueryParams.DEFAULT);
        if (response.getValue() == null || response.getValue().isEmpty()) {
            return Collections.emptyList();
        }

        List<ConsulServer> servers = new ArrayList<>();
        for (HealthService service : response.getValue()) {
            servers.add(new ConsulServer(service));
        }
        */

        List<ConsulServer> servers = new ArrayList<>();
        HealthService healthService = new HealthService();
        HealthService.Service service = new HealthService.Service();
        service.setId(this.serviceId);
        //改造适应k8s, address与serviceId相同,交由k8s注册发现去解析
        service.setAddress(this.serviceId);
        service.setPort(80);
        healthService.setService(service);
        Check check = new Check();
        check.setStatus(Check.CheckStatus.PASSING);
        healthService.setChecks(Arrays.asList(check));
        servers.add(new ConsulServer(healthService));
        return servers;
    }

    private String getTag() {
        return this.properties.getQueryTagForService(this.serviceId);
    }

    @Override
    public String toString() {
        final StringBuffer sb = new StringBuffer("ConsulServerList{");
        sb.append("serviceId='").append(serviceId).append('\'');
        sb.append(", tag=").append(getTag());
        sb.append('}');
        return sb.toString();
    }
}
