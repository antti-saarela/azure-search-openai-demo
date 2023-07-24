# ChatGPT + Enterprise data with Azure OpenAI and Cognitive Search

This sample demonstrates a few approaches for creating ChatGPT-like experiences over your own data using the Retrieval Augmented Generation pattern. It uses Azure OpenAI Service to access the ChatGPT model (gpt-35-turbo), and Azure Cognitive Search for data indexing and retrieval.

The repo includes sample data so it's ready to try end to end. In this sample application we use a fictitious company called Contoso Electronics, and the experience allows its employees to ask questions about the benefits, internal policies, as well as job descriptions and roles.

![RAG Architecture](docs/appcomponents.png)

## Features

* Chat and Q&A interfaces
* Explores various options to help users evaluate the trustworthiness of responses with citations, tracking of source content, etc.
* Shows possible approaches for data preparation, prompt construction, and orchestration of interaction between model (ChatGPT) and retriever (Cognitive Search)
* Settings directly in the UX to tweak the behavior and experiment with options

## Getting Started


> **AZURE RESOURCE COSTS** by default this sample will create Azure App Service and Azure Cognitive Search resources that have a monthly cost, as well as Form Recognizer resource that has cost per document page. You can switch them to free versions of each of them if you want to avoid this cost by changing the parameters file under the infra folder (though there are some limits to consider; for example, you can have up to 1 free Cognitive Search resource per subscription, and the free Form Recognizer resource only analyzes the first 2 pages of each document.)

## Prerequisites

### To Run Locally
- [Azure Developer CLI](https://aka.ms/azure-dev/install)
- [Python 3+](https://www.python.org/downloads/)
    - **Important**: Python and the pip package manager must be in the path in Windows for the setup scripts to work.
    - **Important**: Ensure you can run `python --version` from console. On Ubuntu, you might need to run `sudo apt install python-is-python3` to link `python` to `python3`.    
- [Node.js](https://nodejs.org/en/download/)
- [Git](https://git-scm.com/downloads)
- [Powershell 7+ (pwsh)](https://github.com/powershell/powershell) - For Windows users only.
   - **Important**: Ensure you can run `pwsh.exe` from a PowerShell command. If this fails, you likely need to upgrade PowerShell.

>NOTE: Your Azure Account must have `Microsoft.Authorization/roleAssignments/write` permissions, such as [User Access Administrator](https://learn.microsoft.com/azure/role-based-access-control/built-in-roles#user-access-administrator) or [Owner](https://learn.microsoft.com/azure/role-based-access-control/built-in-roles#owner).  


## Installation

### Project Initialization

1. Create a new folder and switch to it in the terminal
1. Run `azd auth login --tenant-id 81b59a4e-f4e0-4903-be71-0ee63ff2b992`
1. Run `azd init -t azure-search-openai-demo`
    * For the target location, the regions that currently support the models used in this sample are **East US** or **West Europe**. For an up-to-date list of regions and models, check [here](https://learn.microsoft.com/en-us/azure/cognitive-services/openai/concepts/models)

### Starting from scratch:

Execute the following command, if you don't have any pre-existing Azure services and want to start from a fresh deployment.

1. Run `azd up` - This will provision Azure resources and deploy this sample to those resources, including building the search index based on the files found in the `./data` folder.
1. After the application has been successfully deployed you will see a URL printed to the console.  Click that URL to interact with the application in your browser.  

It will look like the following:

!['Output from running azd up'](assets/endpoint.png)
    
> NOTE: It may take a minute for the application to be fully deployed. If you see a "Python Developer" welcome screen, then wait a minute and refresh the page.

### Use existing resources:

1. Run `azd env set AZURE_OPENAI_SERVICE {Name of existing OpenAI service}`
1. Run `azd env set AZURE_OPENAI_RESOURCE_GROUP {Name of existing resource group that OpenAI service is provisioned to}`
1. Run `azd env set AZURE_OPENAI_CHATGPT_DEPLOYMENT {Name of existing ChatGPT deployment}`. Only needed if your ChatGPT deployment is not the default 'chat'.
1. Run `azd env set AZURE_OPENAI_GPT_DEPLOYMENT {Name of existing GPT deployment}`. Only needed if your ChatGPT deployment is not the default 'davinci'.
1. Run `azd up`

```
azd auth login --tenant-id 81b59a4e-f4e0-4903-be71-0ee63ff2b992
```

### Optional settings

```

azd env set AZURE_OPENAI_CHATGPT_DEPLOYMENT {Name of existing ChatGPT deployment}.
azd env set AZURE_OPENAI_GPT_DEPLOYMENT {Name of existing GPT deployment}. 

```

```
azd env list
azd env get-values
```

```
azd up
```

Alternatively you can run first 

```
azd provision
```
and then to deploy the application run
```
azd deploy
```

## Updating the solution

Later to update just the application without re-indexing documents run:

```
azd deploy
```

The command *azd deploy* will not provision Azure resources or do any changes to them.

To change the Azure *infrastructure* or to provision the resources to another resource group etc. run:

```
azd provision
```

> **Note:** The command *azd provision* will provision Azure resources based on the active azd env configuration **and** upload and **index all the documents** in the *data* sub-folder. This may take several hours depending on the amount of document (pages) and will incur some additional Azure costs.


> NOTE: You can also use existing Search and Storage Accounts.  See `./infra/main.parameters.json` for list of environment variables to pass to `azd env set` to configure those existing resources.

#### Deploying or re-deploying a local clone of the repo:
* Simply run `azd up`

### Running locally:
1. Run `azd login`
2. Change dir to `app`
3. Run `./start.ps1` or `./start.sh` or run the "VS Code Task: Start App" to start the project locally.

Open a new terminal with **Powershell**

```

cd app

./start.ps1

```

### Sharing Environments

Run the following if you want to give someone else access to completely deployed and existing environment.

1. Install the [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli)
1. Run `azd init -t azure-search-openai-demo`
1. Run `azd env refresh -e {environment name}` - Note that they will need the azd environment name, subscription Id, and location to run this command - you can find those values in your `./azure/{env name}/.env` file.  This will populate their azd environment's .env file with all the settings needed to run the app locally.
1. Run `pwsh ./scripts/roles.ps1` - This will assign all of the necessary roles to the user so they can run the app locally.  If they do not have the necessary permission to create roles in the subscription, then you may need to run this script for them. Just be sure to set the `AZURE_PRINCIPAL_ID` environment variable in the azd .env file or in the active shell to their Azure Id, which they can get with `az account show`.

## Quickstart

* In Azure: navigate to the Azure WebApp deployed by azd. The URL is printed out when azd completes (as "Endpoint"), or you can find it in the Azure portal.
* Running locally: navigate to 127.0.0.1:5000

Once in the web app:
* Try different topics in chat or Q&A context. For chat, try follow up questions, clarifications, ask to simplify or elaborate on answer, etc.
* Explore citations and sources
* Click on "settings" to try different options, tweak prompts, etc.

## Resources

* [Revolutionize your Enterprise Data with ChatGPT: Next-gen Apps w/ Azure OpenAI and Cognitive Search](https://aka.ms/entgptsearchblog)
* [Azure Cognitive Search](https://learn.microsoft.com/azure/search/search-what-is-azure-search)
* [Azure OpenAI Service](https://learn.microsoft.com/azure/cognitive-services/openai/overview)


## Example questions

Vad är det primära syftet med de Nationella riktlinjer som fastställts av Socialstyrelsen?
Hur bidrar Nationella riktlinjer till förbättring av vårdkvalitet och patientsäkerhet i Sverige?
Kan du ge ett exempel på ett specifikt område inom hälso- och sjukvård som omfattas av Nationella riktlinjer?
Hur utvecklas och uppdateras Nationella riktlinjer för att säkerställa att de förblir relevanta och effektiva?
Vilken roll spelar vårdprofessionella och organisationer i genomförandet av Nationella riktlinjer?

--

Should I register an astma patient to some health registers?
What benefits does it bring if patients are registered?
What health issue is KOL and how it is related to asthma?
How to get reports out of Luftvägsregistret?


# TODO




