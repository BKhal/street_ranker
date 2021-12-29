# Street Ranker
Street Ranker is an application that tracks and visualizes Street Fighter V character usage stats.

## Installation

You will need to have [Docker](https://www.docker.com/products/personal) installed in order to run Street Ranker.

Having [Visual Studio Code](https://code.visualstudio.com/) also installed with the Docker extension is preferable, but optional.

### Method 1: Visual Studio Code

1. Download the project's ZIP folder from the GitHub repository homepage. Repository is found at [https://github.com/BKhal/street_ranker](https://github.com/BKhal/street_ranker). Extract the files and open the new *street_ranker-master* folder in Visual Studio Code.

2. Open the Command Palette using shortcut Ctrl+Shift+P (Cmd+Shift+P on Mac). Type in command `Docker Compose Up` and hit enter.

![Docker Compose example](https://github.com/BKhal/street_ranker/blob/master/assets/images/docker_compose_snip.png?raw=true)

3. The process should take a few minutes to complete. Eventually you should see three new containers if you navigate to the Docker tab on the left of the screen.

![Your new Docker Containers](https://github.com/BKhal/street_ranker/blob/master/assets/images/docker_containers_snip.png?raw=true)

4. The *street_ranker_webscraper* container should start on its own after a few seconds, but if not (or if it suddenly stops running within a few seconds) then give it a minute or two and then Right-Click > Start. This container runs a script that pulls the latest data from [the Capcom website](https://game.capcom.com/cfn/sfv/stats/usagerate). Will take about another minute or two to complete, you'll know it's done when the container stops running.
   - This is an optional step, since the project comes with a bunch of data in the *elasticsearch-data* folder, but it's good to run this container whenever new stats get published to the website.
   
5. If you want to delete all these containers, just run `Docker Compose Down` in the Command Palette.

**Note:** Both the *street_ranker_webscraper* and *kibana* containers require the *elasticsearch* container to be running first.

### Method 2: Command line

All of the above still applies, except for these differences:

1. Open the new folder in Command line/terminal.

2. Execute the following command:

```bash
docker-compose  up -d --build
```

3. You can see a list of all the containers by executing `docker ps -a`, or `docker ps` if you just want to see which ones are currently running. Use this to find the ID of the *street_ranker_webscraper* container.

4. If the *street_ranker_webscraper* container does not start on its own after a minute or two, then execute the command `docker start ID` using the ID found in the previous step. Alternatively it can also be started from the Docker Desktop app.

5. To delete the containers, just run:

```bash
docker-compose  down
```

## Usage

You could just follow [this link](http://localhost:5601/app/dashboards#/view/e5a16ba0-64f1-11ec-88f1-41aa02cbdd00?_g=(filters:!(),refreshInterval:(pause:!t,value:0),time:(from:'2016-10-01T00:00:00.000Z',to:now))), or you can do the following:

Open your web browser and navigate to [localhost:5601](http://localhost:5601). From here, expand the menu on the top left and select *Dashboard* under the *Analytics* tab.

![The Kibana Sidebar](https://github.com/BKhal/street_ranker/blob/master/assets/images/kibana_sidebar_snip.png?raw=true)

Click on *Street Ranker* and you should now see a dashboard that looks something like this:

![The Street Ranker Dashboard](https://github.com/BKhal/street_ranker/blob/master/assets/images/kibana_dashboard_snip.png?raw=true)

If you don't see any line graphs, be sure to change the time range in the upper right so that you are viewing data from October 1, 2016 @ 00:00:00.000 to now. Feel free to change this time range to anything you like if you want a closer look at certain dates.

Also feel free to fiddle with any of the graphs or to create entirely new ones if you like. For more information on how to go about doing that, check out the [Kibana Documentation](https://www.elastic.co/guide/en/kibana/current/index.html).
