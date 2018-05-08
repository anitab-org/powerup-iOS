let diagram;

function load() {

    let model = parse(currentScenario);
    let data = model.data;
    let linkData = model.linkData;

    let $ = go.GraphObject.make;  // for convenience

    // Main diagram template
    diagram =
        $(go.Diagram, "diagram",
            {
                layout: $(go.TreeLayout,
                    {
                        nodeSpacing: 100,
                        layerSpacing: 100
                    }
                ),
                initialContentAlignment: go.Spot.Center, // center content in the diagram view
                initialAutoScale: go.Diagram.Uniform, // zoom-to-fit on load
                validCycle: go.Diagram.CycleNotDirected,  // don't allow loops
                "undoManager.isEnabled": true,
                padding: 150
            }
        );

    // This template is a Panel that is used to represent each item in a Panel.itemArray.
    // The Panel is data bound to the item object.
    let fieldTemplate =
        $(go.Panel, "TableRow",  // this Panel is a row in the containing Table
            $(go.TextBlock,
                {
                    margin: new go.Margin(0, 5),
                    column: 1,
                    font: "bold 13px sans-serif",
                    alignment: go.Spot.Left,
                    fromLinkable: false,
                    toLinkable: false
                },
                new go.Binding("text", "name")
            ),
            $(go.TextBlock,
                {
                    margin: new go.Margin(0, 5),
                    width: 100, column: 2,
                    font: "13px sans-serif",
                    alignment: go.Spot.Left,
                    wrap: go.TextBlock.WrapFit
                },
                new go.Binding("text", "info")
            )
        );

    // This template represents a whole "record".
    diagram.nodeTemplate =
        $(go.Node, "Auto",
            {
                layoutConditions: go.Part.LayoutStandard & ~go.Part.LayoutNodeSized,
                fromSpot: go.Spot.AllSides,
                toSpot: go.Spot.AllSides,
                isShadowed: true,
                shadowColor: "#C5C1AA"
            },
            new go.Binding("location", "loc", go.Point.parse).makeTwoWay(go.Point.stringify),
            // this rectangular shape surrounds the content of the node
            $(go.Shape,
                { fill: "#EEEEEE" }
            ),
            // the content consists of a header and a list of items
            $(go.Panel, "Vertical",
                // this is the header for the whole node
                $(go.Panel, "Auto",
                    { stretch: go.GraphObject.Horizontal },  // as wide as the whole node
                    $(go.Shape,
                        { fill: "#1570A6", stroke: null },
                        new go.Binding("fill", "color")
                    ),
                    $(go.TextBlock,
                        {
                            alignment: go.Spot.Center,
                            margin: 3,
                            stroke: "white",
                            textAlign: "center",
                            font: "bold 12pt sans-serif"
                        },
                        new go.Binding("text", "key")
                    )
                ),
                // this Panel holds a Panel for each item object in the itemArray;
                // each item Panel is defined by the itemTemplate to be a TableRow in this Table
                $(go.Panel, "Table",
                    {
                        padding: 2,
                        minSize: new go.Size(100, 10),
                        defaultStretch: go.GraphObject.Horizontal,
                        itemTemplate: fieldTemplate
                    },
                    new go.Binding("itemArray", "fields")
                )  // end Table Panel of items
            )  // end Vertical Panel
        );  // end Node

    diagram.linkTemplate =
        $(go.Link,
            {
                routing: go.Link.AvoidsNodes,
                curve: go.Link.JumpGap
            },
            $(go.Shape, { strokeWidth: 1.5 }, new go.Binding("stroke", "color")),
            $(go.Shape, { toArrow: "Standard" }, new go.Binding("stroke", "color"), new go.Binding("fill", "color"))
        );

    diagram.model =
        $(go.GraphLinksModel,
            {
                linkFromPortIdProperty: "fromPort",
                linkToPortIdProperty: "toPort",
                nodeDataArray: data,
                linkDataArray: linkData
            }
        );
}