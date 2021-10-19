using Dates

include("structures.jl")



function n_in_ns(n, nns)
    for nn in nns
        if nn.name == n.name
            return true
        end
    end
    return false
end

function main()

    nodes = []
    processes = []
    dates = [Dates.DateTime("2020-01-01T00:00:00"), Dates.DateTime("2020-01-02T00:00:00"), Dates.DateTime("2020-01-03T00:00:00"), Dates.DateTime("2020-01-04T00:00:00"), Dates.DateTime("2020-01-05T00:00:00"), Dates.DateTime("2020-01-06T00:00:00"), Dates.DateTime("2020-01-07T00:00:00"), Dates.DateTime("2020-01-08T00:00:00"), Dates.DateTime("2020-01-09T00:00:00"), Dates.DateTime("2020-01-10T00:00:00")]

    #push!(nodes,Node(0, "dhA", "dh", [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], true, true, true))
    #push!(nodes,Node(0, "elecA", "elec", [10.0, 11.0, 12.0, 12.0, 10.0, 13.0, 13.0, 13.0, 12.0, 11.0], true, true, true))
    #push!(nodes,Node(0, "h2A", "h2", [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], true, true, true))
    #push!(nodes,Node(0, "solarA", "solar", [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], true, false, false))
    #push!(nodes,Node(0, "gasA", "gas", [8.0, 7.0, 8.0, 10.0, 9.0, 8.0, 7.0, 9.0, 8.0, 6.0], false, true, false))
    #push!(nodes,Node(0, "dhB", "dh", [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], true, true, true))

    p = Process(0, "p2x", true, 0.7, 0.2, 1.0, 10.0, 1.0, 0.2, 0.1)
    soN = Node(0, "elecA", "elec", [10.0, 11.0, 12.0, 12.0, 10.0, 13.0, 13.0, 13.0, 12.0, 11.0], true, true, true)
    siN = Node(0, "h2A", "h2", [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], true, true, true)
    push!(p.sinks, soN)
    push!(p.sources, siN)
    push!(processes, p)
    if !n_in_ns(soN, nodes)
        push!(nodes, soN)
    end
    if !n_in_ns(siN, nodes)
        push!(nodes, siN)
    end

    p = Process(0, "x2p", true, 0.65, 0.1, 1.0, 10.0, 1.0, 0.3, 0.3)
    soN = Node(0, "h2A", "h2", [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], true, true, true)
    siN = Node(0, "elecA", "elec", [10.0, 11.0, 12.0, 12.0, 10.0, 13.0, 13.0, 13.0, 12.0, 11.0], true, true, true)
    push!(p.sinks, soN)
    push!(p.sources, siN)
    push!(processes, p)
    if !n_in_ns(soN, nodes)
        push!(nodes, soN)
    end
    if !n_in_ns(siN, nodes)
        push!(nodes, siN)
    end

    p = Process(0, "hp", true, 0.4, 0.2, 1.0, 5.0, 1.0, 0.1, 0.4)
    soN = Node(0, "elecA", "elec", [10.0, 11.0, 12.0, 12.0, 10.0, 13.0, 13.0, 13.0, 12.0, 11.0], true, true, true)
    siN = Node(0, "dhA", "dh", [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], true, true, true)
    push!(p.sinks, soN)
    push!(p.sources, siN)
    push!(processes, p)
    if !n_in_ns(soN, nodes)
        push!(nodes, soN)
    end
    if !n_in_ns(siN, nodes)
        push!(nodes, siN)
    end

    p = Process(0, "ngchp_dh", true, 0.5, 0.3, 1.0, 5.0, 1.0, 0.2, 0.4)
    soN = Node(0, "gasA", "gas", [8.0, 7.0, 8.0, 10.0, 9.0, 8.0, 7.0, 9.0, 8.0, 6.0], false, true, false)
    siN = Node(0, "dhA", "dh", [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], true, true, true)
    push!(p.sinks, soN)
    push!(p.sources, siN)
    push!(processes, p)
    if !n_in_ns(soN, nodes)
        push!(nodes, soN)
    end
    if !n_in_ns(siN, nodes)
        push!(nodes, siN)
    end

    p = Process(0, "ngchp_elec", true, 0.35, 0.4, 1.0, 4.0, 1.0, 0.2, 0.2)
    soN = Node(0, "gasA", "gas", [8.0, 7.0, 8.0, 10.0, 9.0, 8.0, 7.0, 9.0, 8.0, 6.0], false, true, false)
    siN = Node(0, "elecA", "elec", [10.0, 11.0, 12.0, 12.0, 10.0, 13.0, 13.0, 13.0, 12.0, 11.0], true, true, true)
    push!(p.sinks, soN)
    push!(p.sources, siN)
    push!(processes, p)
    if !n_in_ns(soN, nodes)
        push!(nodes, soN)
    end
    if !n_in_ns(siN, nodes)
        push!(nodes, siN)
    end

    p = Process(0, "pv", true, 3.0, 0.0, 1.0, 5.0, 2.0, 0.4, 0.3)
    soN = Node(0, "solarA", "solar", [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], true, false, false)
    siN = Node(0, "elecA", "elec", [10.0, 11.0, 12.0, 12.0, 10.0, 13.0, 13.0, 13.0, 12.0, 11.0], true, true, true)
    push!(p.sinks, soN)
    push!(p.sources, siN)
    push!(processes, p)
    if !n_in_ns(soN, nodes)
        push!(nodes, soN)
    end
    if !n_in_ns(siN, nodes)
        push!(nodes, siN)
    end

    p = Process(0, "transfer_dhA_dhB", true, 0.99, 0.0, 1.0, 3.0, 0.0, 1.0, 1.0)
    soN = Node(0, "dhA", "dh", [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], true, true, true)
    siN = Node(0, "dhB", "dh", [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], true, true, true)
    push!(p.sinks, soN)
    push!(p.sources, siN)
    push!(processes, p)
    if !n_in_ns(soN, nodes)
        push!(nodes, soN)
    end
    if !n_in_ns(siN, nodes)
        push!(nodes, siN)
    end

    p = Process(0, "transfer_dhB_dhA", true, 0.99, 0.0, 1.0, 3.0, 0.0, 1.0, 1.0)
    soN = Node(0, "dhB", "dh", [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], true, true, true)
    siN = Node(0, "dhA", "dh", [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], true, true, true)
    push!(p.sinks, soN)
    push!(p.sources, siN)
    push!(processes, p)
    if !n_in_ns(soN, nodes)
        push!(nodes, soN)
    end
    if !n_in_ns(siN, nodes)
        push!(nodes, siN)
    end

    demand = Demand()
    push!(demand.demands, (nodes[3], [-1.8, -3.5, -6.6, -12.7, -12.8, -10.0, -7.7, -7.6, -2.5, -3.7]))
    push!(demand.demands, (nodes[1], [-2.0, -2.0, -2.0, -2.0, -2.0, -2.0, -2.0, -2.0, -2.0, -2.0]))
    push!(demand.demands, (nodes[2], [-1.0, -0.3, -0.1, -0.2, -0.9, -0.4, -1.4, -1.1, -0.1, -1.7]))


    #push!(demand.demands, (Node(0, "dhA", "dh", [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], true, true, true), [-1.8, -3.5, -6.6, -12.7, -12.8, -10.0, -7.7, -7.6, -2.5, -3.7]))
    #push!(demand.demands, (Node(0, "elecA", "elec", [10.0, 11.0, 12.0, 12.0, 10.0, 13.0, 13.0, 13.0, 12.0, 11.0], true, true, true), [-2.0, -2.0, -2.0, -2.0, -2.0, -2.0, -2.0, -2.0, -2.0, -2.0]))
    #push!(demand.demands, (Node(0, "h2A", "h2", [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], true, true, true), [-1.0, -0.3, -0.1, -0.2, -0.9, -0.4, -1.4, -1.1, -0.1, -1.7]))
    return (dates, nodes, processes, demand)
end